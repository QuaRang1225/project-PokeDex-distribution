//
//  MainFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/17/25.
//

import Foundation
import ComposableArchitecture

/// 메인 Feature
struct MainFeature: Reducer {
    typealias PokemonResult = Result<PokemonList, NetworkError>
    
    /// 포켓몬 쿼리 구조체
    struct PokemonsQuery: Equatable {
        var page: Int = 1
        var region: String = RegionFilter.national.rawValue
        var types: Types = Types()
        var query: String = ""
    }
    
    @ObservableState struct State: Equatable {
        var pokemons: PokemonList? = nil                                            // 포켓몬 리스트
        var isLoading: Bool = false                                                 // 로딩 중
        var showSearchBoard = false                                                 // 검색 보드뷰 표시
        var regionTitle: String = RegionFilter.national.rawValue                    // 지방 이름
        var currentQuery = PokemonsQuery()                                          // 현재 쿼리 상태
        var isLastPokemonReached: Bool = true
        
        var pokemonCellStates: IdentifiedArrayOf<PokemonCellFeature.State> = []     // 포켓몬 리스트 셀 상태 배열
        
        // 하위 Feature 상태 정의
        var searchBoardState = SearchBoardFeature.State()                           // 검색보드 상태
        var pokemonDetailsState: PokemonDetailsFeature.State? = nil                     // 포켓몬 상세 뷰 상태
    }
    
    @CasePathable enum Action: Equatable {
        case viewDidLoad                                                            // 뷰 로드 후
        case recievedPokemons(result: PokemonResult, isAppend: Bool)                // 데이터 요청 후
        case didTappedSearchButton                                                  // 검색 버튼 터치
        case scrollUpList
        case lastPokemonReached
        case delegate(Delegate)                                                     // 상위 Feature에서 구현할 액션
        
        // 하위 Feature 액션 정의
        case searchBoardAction(action: SearchBoardFeature.Action)                   // 검색보드 액션
        case pokemonDetailsAction(action: PokemonDetailsFeature.Action)             // 포켓몬 상세 뷰 액션
        
        // 포켓몬 선택 관련 액션 정의
        case pokemonCellFeature(IdentifiedActionOf<PokemonCellFeature>)             // 포켓몬 셀 상태, 액션 정의
        case dismissSearchView// 상세화면 열기
        case dismissPokemonDetail                                                   // 상세화면 닫기
        
        enum Delegate: Equatable {
            case selectedRegion(region: String)                                     // 지역 선택
        }
    }
    
    @Dependency(\.pokemonListClient) var pokemonListClient
    
    var body: some ReducerOf<Self> {
        // 하위 이벤트 연결
        Scope(state: \.searchBoardState, action: \.searchBoardAction) { SearchBoardFeature() }
        
        Reduce { state, action in
            switch action {
            case .viewDidLoad:
                return fetchPokemons(&state)
            case let .recievedPokemons(result, isAppend):
                return setPokemons(&state, result: result, isAppend: isAppend)
            case .didTappedSearchButton:
                return showSearchBoard(&state)
            case let .searchBoardAction(action):
                return executeSearchBoardFeature(&state, action: action)
            case .scrollUpList:
                return fetchNextPokemons(&state)
            case .lastPokemonReached:
                return lastPokemonReached(&state)
            case let .delegate(.selectedRegion(region)):
                return fetchPokemons(&state, query: PokemonsQuery(region: region))
            case let .pokemonCellFeature(.element(id, .delegate(.didTapCell))):
                return movePokemonDetailsView(&state, id: id)
            case .dismissPokemonDetail:
                return dismissPokemonDetailsView(&state)
            case .dismissSearchView:
                return dismissSearchBoard(&state)
            case let .pokemonDetailsAction(action):
                return executePokemonDetailFeature(&state, action: action)
            }
        }
        .forEach(\.pokemonCellStates, action: \.pokemonCellFeature) {
            PokemonCellFeature()
        }
        .ifLet(\.pokemonDetailsState, action: \.pokemonDetailsAction) {
            PokemonDetailsFeature()
        }
    }
    
    /// 포켓몬 리스트 요청
    private func fetchPokemons(_ state: inout State, query: PokemonsQuery = PokemonsQuery()) -> Effect<Action> {
        state.isLoading = true
        state.pokemons = nil
        state.regionTitle = query.region
        state.currentQuery = query
        return .run { send in
            do {
                let pokemons = try await pokemonListClient.fetchPokemons(query.page, query.region, query.types, query.query)
                await send(.recievedPokemons(result: .success(pokemons), isAppend: false))
            } catch let error as NetworkError {
                await send(.recievedPokemons(result: .failure(error), isAppend: false))
            }
        }
    }
    
    /// 포켓몬 리스트  업데이트 및 에러 핸들링
    private func setPokemons(_ state: inout State, result: PokemonResult, isAppend: Bool = false) -> Effect<Action> {
        state.isLoading = false
        
        switch result {
        case let .success(pokemons):
            if isAppend {
                // 기존 pokemons 리스트에 새 데이터 append
                state.pokemons?.pokemons.append(contentsOf: pokemons.pokemons)
                
                // 기존 셀 상태 배열에 새 셀 추가
                state.pokemonCellStates.append(
                    contentsOf: pokemons.pokemons.map { PokemonCellFeature.State(pokemon: $0) }
                )
            } else {
                state.pokemons = pokemons
                state.pokemonCellStates = IdentifiedArray(
                    uniqueElements: pokemons.pokemons.map { PokemonCellFeature.State(pokemon: $0) }
                )
            }
        case let .failure(error):
            print(error.errorMessage)
        }
        
        return .none
    }
    
    /// 포켓몬 리스트 다음 요청
    private func fetchNextPokemons(_ state: inout State) -> Effect<Action> {
        // 현재 페이지가 총 페이지 수보다 작을 때만 실행
        guard let currentPage = state.pokemons?.currentPage,
              let totalPage = state.pokemons?.totalPages,
              currentPage < totalPage else {
            // 아닐 경우 마지막이라는 이벤트 방출
            return .send(.lastPokemonReached)
        }
        state.currentQuery.page += 1
        state.pokemons?.currentPage += 1
        let query = state.currentQuery
        
        return .run { send in
            do {
                let pokemons = try await pokemonListClient.fetchPokemons(query.page, query.region, query.types, query.query)
                await send(.recievedPokemons(result: .success(pokemons), isAppend: true))
            } catch let error as NetworkError {
                await send(.recievedPokemons(result: .failure(error), isAppend: true))
            }
        }
    }
    
    /// 마지막 이벤트의 경우 ProgressView를 끄기 위한 이벤트
    private func lastPokemonReached(_ state: inout State) -> Effect<Action> {
        state.isLastPokemonReached = false
        return .none
    }
    
    /// 검색 보드 표시
    private func showSearchBoard(_ state: inout State) -> Effect<Action> {
        state.showSearchBoard = true
        return .none
    }
    
    /// 검색 보드 닫기
    private func dismissSearchBoard(_ state: inout State) -> Effect<Action> {
        state.showSearchBoard = false
        return .none
    }
    
    /// 포켓몬 상세 뷰 이동
    private func movePokemonDetailsView(_ state: inout State, id: Int) -> Effect<Action> {
        state.pokemonDetailsState = PokemonDetailsFeature.State(id: id)
        return .none
    }
    
    /// 포켓몬 상세 뷰 닫기
    private func dismissPokemonDetailsView(_ state: inout State) -> Effect<Action> {
        state.pokemonDetailsState = nil
        return .none
    }
}


// MARK: - 검색 보드 이벤트
extension MainFeature {
    /// 검색보드 이벤트 실행자
    private func executeSearchBoardFeature(_ state: inout State, action: SearchBoardFeature.Action) -> Effect<Action> {
        switch action {
        case .delegate(.didTappedSearchButton):
            state.showSearchBoard = false
            let query = state.searchBoardState.query
            let types = Types(first: state.searchBoardState.types.first, last: state.searchBoardState.types.last)
            let pokemon = PokemonsQuery(types: types, query: query)
            return fetchPokemons(&state, query: pokemon)
        default: return .none
        }
    }
}

// MARK: - 포켓몬 상세 뷰 이벤트
extension MainFeature {
    private func executePokemonDetailFeature(_ state: inout State, action: PokemonDetailsFeature.Action) -> Effect<Action> {
        switch action {
        case .delegate(.dismissView):
            return dismissPokemonDetailsView(&state)
        default: return .none
        }
    }
}
