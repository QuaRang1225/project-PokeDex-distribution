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
    
    struct State: Equatable {
        var pokemons: PokemonList? = nil                                        // 포켓몬 리스트
        var isLoading: Bool = false                                             // 로딩 중
    }
    
    enum Action: Equatable {
        case viewDidLoad(page: Int, region: String, types: Types, query: String)   // 뷰 로드 후
        case recievedPokemons(PokemonResult)                                    // 데이터 요청 후
    }
    
    @Dependency(\.pokemonListClient) var pokemonListClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .viewDidLoad(page, region, types, query):
            return fetchPokemons(&state, page: page, region: region, types: types, query: query)
        case let .recievedPokemons(result):
            return setPokemons(&state, result: result)
        }
    }
    
    /// 포켓몬 리스트 요청
    private func fetchPokemons(_ state: inout State, page: Int, region: String, types: Types, query: String) -> Effect<Action> {
        state.isLoading = true
        return .run { send in
            do {
                let pokemons = try await pokemonListClient.fetchPokemons(page, region, types, query)
                await send(.recievedPokemons(.success(pokemons)))
            } catch let error as NetworkError {
                await send(.recievedPokemons(.failure(error)))
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
}
