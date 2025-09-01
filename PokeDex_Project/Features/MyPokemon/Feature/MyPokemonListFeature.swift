//
//  BookMarkFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/28/25.
//

import Foundation
import ComposableArchitecture

/// 북마크 Feature
struct MyPokemonListFeature: Reducer {
    
    @ObservableState struct State: Equatable {
        var pokemons: [RealmPokemon] = []                                               // 저장된 포켓몬 리스트
        var pokemon: RealmPokemon? = nil                                                // 선택할 포켓몬
        var isLoading: Bool = false                                                     // 로딩 중
        
        var pokemonDetailState: PokemonDetailsFeature.State? = nil                      // 포켓몬 상세 뷰 상태
    }
    /// 사용자 액션
    @CasePathable enum ViewAction: Equatable {
        case viewDidLoad                                                                // 뷰 등장
        case removePokemon(_ offsets: IndexSet)                                         // 내 포켓몬 삭제
        case removeAllPokemon                                                           // 모든 포켓몬 삭제
        case movePokemon(_ fromOffsets: IndexSet, _ toOffset: Int)                      // 내 포켓몬 이동
        case didTappedPokemonCell(_ id: Int)                                            // 셀 터치 시
    }
    /// 하위뷰 사용자 액션
    @CasePathable enum ChildViewAction: Equatable {
        case dismissPokemonDetail                                                       // 포켓몬 상세 화면 닫기
    }
    /// 내부 액션
    @CasePathable enum InsideAction: Equatable {
        case setPokemons(_ pokemons: [RealmPokemon])                                    // 내 포켓몬 세팅
    }
    /// 하위 Feature 액션
    @CasePathable enum ChildAction: Equatable {
        case pokemonDetailsAction(action: PokemonDetailsFeature.Action)                 // 포켓몬 상세 뷰 액션
    }
    /// 액션 정의
    @CasePathable enum Action: Equatable {
        case view(ViewAction)
        case childView(ChildViewAction)
        case inside(InsideAction)
        case child(ChildAction)
    }
    
    @Dependency(\.realmClient) var realmClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewActiom):
                switch viewActiom {
                case .viewDidLoad:
                    return fetchPokemons(&state)
                case let .removePokemon(offsets):
                    return removePokemon(&state, offsets: offsets)
                case .removeAllPokemon:
                    return removeAll(&state)
                case let .movePokemon(fromOffsets, toOffset):
                    return movePokemon(&state, fromOffsets: fromOffsets, toOffset: toOffset)
                case let .didTappedPokemonCell(id):
                    return movePokemonDetailsView(&state, id: id)
                }
            case let .inside(insideAction):
                switch insideAction {
                case let .setPokemons(pokemons):
                    return setPokemons(&state, pokemons: pokemons)
                }
            case let .child(childAction):
                switch childAction {
                case let .pokemonDetailsAction(action):
                    return executePokemonDetailFeature(&state, action: action)
                }
            default: return .none
            }
        }
        .ifLet(\.pokemonDetailState, action: \.child.pokemonDetailsAction) {
            PokemonDetailsFeature()
        }
    }
    /// 포켓몬 요청
    private func fetchPokemons(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        return .run { send in
            do {
                let pokemons = try await realmClient.fetchPokemons()
                await send(.inside(.setPokemons(pokemons)))
            } catch let error as RealmError {
                print(error.errorMessage)
            }
        }
    }
    /// 포켓몬 세팅
    private func setPokemons(_ state: inout State, pokemons: [RealmPokemon]) -> Effect<Action> {
        let currentPokemons = state.pokemons
        if pokemons != currentPokemons {            // 현재 포켓몬과 같지 않을 때만 배열 업데이트
            state.pokemons = pokemons
        }
        state.isLoading = false
        return .none
    }
    /// 포켓몬 북마크 삭제
    private func removePokemon(_ state: inout State, offsets: IndexSet) -> Effect<Action> {
        guard let id = offsets.first else { return .none }
        let deleteToNum = state.pokemons[id].num
        let pokemons = state.pokemons.filter { $0.num != deleteToNum }
        return .run { send in
            do {
                try await realmClient.deletePokemon(deleteToNum)
                await send(.inside(.setPokemons(pokemons)))
            } catch let error as RealmError {
                print(error.errorMessage)
            }
        }
    }
    /// 포켓몬 북마크 전체 삭제
    private func removeAll(_ state: inout State) -> Effect<Action> {
        return .run { send in
            do {
                try await realmClient.deleteAllPokemons()
                await send(.inside(.setPokemons([])))
            } catch let error as RealmError {
                print(error.errorMessage)
            }
        }
    }
    /// 포켓몬 북마크 이동
    private func movePokemon(_ state: inout State, fromOffsets: IndexSet, toOffset: Int) -> Effect<Action> {
        state.pokemons.move(fromOffsets: fromOffsets, toOffset: toOffset)
        return .none
    }
    /// 포켓몬 상세 뷰 닫기
    private func dismissPokemonDetailsView(_ state: inout State) -> Effect<Action> {
        state.pokemonDetailState = nil
        return .none
    }
    /// 포켓몬 상세 뷰 이동
    private func movePokemonDetailsView(_ state: inout State, id: Int) -> Effect<Action> {
        state.pokemonDetailState = PokemonDetailsFeature.State(id: id)
        return .none
    }
}

// MARK: - 포켓몬 상세 뷰 이벤트
extension MyPokemonListFeature {
    private func executePokemonDetailFeature(_ state: inout State, action: PokemonDetailsFeature.Action) -> Effect<Action> {
        switch action {
        case .delegate(.dismissView):
            return dismissPokemonDetailsView(&state)
        default: return .none
        }
    }
}
