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
    
    struct PoekmonsQuery {
        var page: Int = 1
        var region: String = RegionFilter.national.rawValue
        var types: Types = Types()
        var query: String = ""
    }
    
    struct State: Equatable {
        var pokemons: PokemonList? = nil                                            // 포켓몬 리스트
        var isLoading: Bool = false                                                 // 로딩 중
        var showSearchBoard = false                                                 // 검색 보드뷰 표시
        var regionTitle: String = RegionFilter.national.rawValue                    // 지방 이름
        
        // 하위 Feature 상태 정의
        var searchBoardState = SearchBoardFeature.State()                           // 검색보드 상태
    }
    
    @CasePathable enum Action: Equatable {
        case viewDidLoad                                                            // 뷰 로드 후
        case recievedPokemons(result: PokemonResult)                                // 데이터 요청 후
        case didTappedSearchButton                                                  // 검색 버튼 터치
        case delegate(Delegate)
        
        // 하위 Feature 액션 정의
        case searchBoardAction(action: SearchBoardFeature.Action)                   // 검색보드 액션
        
        enum Delegate: Equatable {
            case selectedRegion(region: String)
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
            case let .recievedPokemons(result):
                return setPokemons(&state, result: result)
            case .didTappedSearchButton:
                return showSearchBoard(&state)
            case let .searchBoardAction(action):
                return executeSearchBoardFeature(&state, action: action)
            case let .delegate(.selectedRegion(region)):
                return fetchPokemons(&state, query: PoekmonsQuery(region: region))
            }
        }
    }
    
    /// 포켓몬 리스트 요청
    private func fetchPokemons(_ state: inout State, query: PoekmonsQuery = PoekmonsQuery()) -> Effect<Action> {
        state.isLoading = true
        state.pokemons = nil
        state.regionTitle = query.region
        return .run { send in
            do {
                let pokemons = try await pokemonListClient.fetchPokemons(query.page, query.region, query.types, query.query)
                await send(.recievedPokemons(result: .success(pokemons)))
            } catch let error as NetworkError {
                await send(.recievedPokemons(result: .failure(error)))
            }
        }
    }

    /// 포켓몬 리스트  업데이트 및 에러 핸들링
    private func setPokemons(_ state: inout State, result: PokemonResult) -> Effect<Action> {
        state.isLoading = false

        switch result {
        case let .success(pokemons):
            state.pokemons = pokemons
        case let .failure(error):
            print(error.errorMessage)
        }

        return .none
    }
    
    /// 검색 보드 표시
    private func showSearchBoard(_ state: inout State) -> Effect<Action> {
        state.showSearchBoard.toggle()
        return .none
    }
}


// MARK: - 검색 보드 이벤트
extension MainFeature {
    /// 검색보드 이벤트 실행자
    private func executeSearchBoardFeature(_ state: inout State, action: SearchBoardFeature.Action) -> Effect<Action> {
        
    }
}
