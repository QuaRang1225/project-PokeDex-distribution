//
//  PokemonDetailsFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/22/25.
//

import Foundation
import RealmSwift
import ComposableArchitecture

/// 포켓몬 상세 Feature
struct PokemonDetailsFeature: Reducer {
    
    /// 포켓몬 상세정보 구조화
    struct PokemonDetails: Equatable {
        var pokemon: Pokemon
        var varieties: [Varieties]
        var evolution: EvolutionTo
    }
    
    @ObservableState struct State: Equatable {
        var id: Int                                 // 포켓몬 ID
        var pokemon: Pokemon? = nil                 // 포켓몬 정보
        var variety: Varieties? = nil               // 리전 폼
        var varieties: [Varieties] = []             // 리전 폼 리스트
        var isBookmarked: Bool = false              // 북마크 여부
        var isLoading: Bool = false                 // 로딩 중
        
        var evoltionTreeState: EvolutionTreeFeature.State? = nil
    }
    
    @CasePathable enum Action: Equatable {
        case viewDidLoad                                                            // 뷰 로드 시
        case setPokemonDetails(_ result: Result<PokemonDetails, NetworkError>)      // 포켓몬 상세 정보 세팅
        case didTappedVarietyCell(_ variety: Varieties)                             // 다른 모습 셀 터치 시
        case didTappedBackButton                                                    // 뒤로 가기 버튼 터치 시
        case didTappedNext
        case didTappedPrevious
        case didTappedEvolution(_ id: Int)
        case evoltionTreeAction(_ action: EvolutionTreeFeature.Action)
        case evolutionTreeDelegate(EvolutionTreeFeature.Action.Delegate)
        case didTappedHeartButton
        case setBookmark(_ isBookmarked: Bool)                                      // 북마크 상태 저장
        case delegate(_ delegate: Delegate)                                         // delegate
        
        enum Delegate: Equatable {
            case dismissView                                                        // 뷰 닫는 이벤트
        }
    }
    
    @Dependency(\.pokemonDetailsClient) var pokemonDetailsClient
    @Dependency(\.realmClient) var realmClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewDidLoad:
                return fetchPokemonDetails(&state, id: state.id)
            case let .setPokemonDetails(result):
                return setPokemonDetails(&state, result: result)
            case let .didTappedVarietyCell(variety):
                return updataVariety(&state, variety: variety)
            case .didTappedBackButton:
                return dismissView(&state)
            case .didTappedNext:
                return fetchNextPokemon(&state, id: state.id)
            case .didTappedPrevious:
                return fetchPreviousPokemon(&state, id: state.id)
            case let .didTappedEvolution(id):
                return fetchPokemonDetails(&state, id: id)
            case let .evoltionTreeAction(action):
                return executeEvolutionTreeAction(&state, action: action)
            case .didTappedHeartButton:
                return toggleHeart(&state)
            case let .setBookmark(isBookmark):
                return setBookmark(&state, isBookmarked: isBookmark)
            default: return .none
            }
        }
        .ifLet(\.evoltionTreeState, action: \.evoltionTreeAction) {
            EvolutionTreeFeature()
        }
    }
    
    /// 포켓몬 상세 뷰 요철
    private func fetchPokemonDetails(_ state: inout State, id: Int) -> Effect<Action> {
        state.isLoading = true
        return .run { send in
            do {
                // 포켓몬 요청
                let pokemon = try await pokemonDetailsClient.fetchPokemon(id)
                
                // 받아온 포켓몬 정보로 진화트리와 리전 폼 데이터 추출
                guard let fetchedEvolutionTree = pokemon.evolutionTree,
                      let fetchedVarieties = pokemon.varieties
                else {
                    return await send(.setPokemonDetails(.failure(NetworkError.decodingFailed)))
                }
                
                // 진화 트리 및 리전 폼 요청
                // 폼 정보는 id가 적은 순으로 정렬
                async let evolution = pokemonDetailsClient.fetchEvolution(fetchedEvolutionTree)
                async let varieties = fetchedVarieties.fetchAsync { try await pokemonDetailsClient.fetchVariety($0) }
                let sortedVarieties = try await varieties.sorted(by: { $0.form.id.first ?? 0 < $1.form.id.first ?? 0 })
                
                // 전체 화면에 필요한 상세 정보 하나로 묶음
                let details = try await PokemonDetails(pokemon: pokemon, varieties: sortedVarieties, evolution: evolution)
                
                return await send(.setPokemonDetails(.success(details)))
            } catch let error as NetworkError{
                return await send(.setPokemonDetails(.failure(error)))
            }
        }
    }
    
    /// 포켓몬 상세 정보 저장
    private func setPokemonDetails(_ state: inout State, result: Result<PokemonDetails, NetworkError>) -> Effect<Action> {
        switch result {
        case let .success(details):
            state.isLoading = false
            state.pokemon = details.pokemon
            state.evoltionTreeState = EvolutionTreeFeature.State(node: details.evolution)
            state.varieties = (details.varieties.first?.makeVariety() ?? []) + details.varieties.dropFirst()
            state.variety = details.varieties.first?.makeVariety().first
        case let .failure(error):
            print("포켓몬 요청 에러: " + error.errorMessage)
        }
        return readIsBookmarked(&state)
    }
    /// 폼 업데이트
    private func updataVariety(_ state: inout State, variety: Varieties) -> Effect<Action> {
        state.variety = variety
        return .none
    }
    /// 뷰 닫음
    private func dismissView(_ state: inout State) -> Effect<Action> {
        return .send(.delegate(.dismissView))
    }
    /// 다음 포켓몬 요청 
    private func fetchNextPokemon(_ state: inout State, id: Int) -> Effect<Action> {
        let id = id == Int.lastPoekmonIndex ? Int.firstPoekmonIndex : id + 1
        state.id = id
        return fetchPokemonDetails(&state, id: id)
    }
    /// 이전 포켓몬 요청
    private func fetchPreviousPokemon(_ state: inout State, id: Int) -> Effect<Action> {
        let id = id == Int.firstPoekmonIndex ? Int.lastPoekmonIndex : id - 1
        state.id = id
        return fetchPokemonDetails(&state, id: id)
    }
    /// 북마크 토글
    private func toggleHeart(_ state: inout State) -> Effect<Action> {
        return state.isBookmarked ? deletePokemon(&state) : savePokemon(&state)
    }
    /// 포켓몬 저장
    private func savePokemon(_ state: inout State) -> Effect<Action> {
        state.isBookmarked = true
        
        let num = state.pokemon?.id ?? 0
        let name = (state.pokemon?.name ?? "") + (state.variety?.form.name.first?.insertParentheses ?? "")
        let image = state.variety?.form.images.first ?? ""
        let types = state.variety?.types ?? []
        
        return .run { send in
            let typeList = RealmSwift.List<String>()
            typeList.append(objectsIn: types)
            
            let object = RealmObject()
            object.num = num
            object.name = name
            object.image = image
            object.types = typeList
            
            do {
                try await realmClient.storePokemon(object)
            } catch let error as RealmError {
                print(error.errorMessage)
            }
        }
    }
    /// 포켓몬 삭제
    private func deletePokemon(_ state: inout State) -> Effect<Action> {
        state.isBookmarked = false
        let id = state.pokemon?.id ?? 0
        return .run { send in
            do {
                try await realmClient.deletePokemon(id)
            } catch let error as RealmError {
                print(error.errorMessage)
            }
        }
    }
    /// 북마크 여부 요청
    private func readIsBookmarked(_ state: inout State) -> Effect<Action> {
        let id = state.pokemon?.id ?? 0
        return .run { send in
            let isBookmarked = try await realmClient.readIsBookmarked(id)
            await send(.setBookmark(isBookmarked))
        }
    }
    /// 북마크 상태 저장
    private func setBookmark(_ state: inout State, isBookmarked: Bool) -> Effect<Action> {
        state.isBookmarked = isBookmarked
        return .none
    }
}

// MARK: - 진화트리 액션
extension PokemonDetailsFeature {
    /// 진화트리 이벤트 실행
    private func executeEvolutionTreeAction(_ state: inout State, action: EvolutionTreeFeature.Action) -> Effect<Action> {
        switch action {
        case let .delegate(.eventEvolution(id)):
            return fetchPokemonDetails(&state, id: id ?? 0)
        default: return .none
        }
    }
}
