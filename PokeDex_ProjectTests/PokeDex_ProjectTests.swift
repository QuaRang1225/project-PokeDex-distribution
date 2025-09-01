//
//  PokeDex_ProjectTests.swift
//  PokeDex_ProjectTests
//
//  Created by Quarang on 9/1/25.
//

import XCTest
import ComposableArchitecture
@testable import PokeDex_Project

final class PokeDex_ProjectTests: XCTestCase {

    /// 포켓몬 리스트 요청 태스트
    func testFetchPokemonsSuccess() async throws {
        let mockPokemonList = PokemonList(
            totalCount: 1025,
            totalPages: 52,
            currentPage: 1,
            perPage: 20,
            pokemons: []
        )
        
        let store = await TestStore(initialState: MainFeature.State()) {
            MainFeature()
        } withDependencies: {
            $0.pokemonListClient.fetchPokemons = { _, _, _, _ in
                return mockPokemonList
            }
        }
        
        await store.send(.view(.viewDidLoad)) {
            $0.isLoading = true
            $0.pokemons = nil
            $0.regionTitle = "전국"  // 기본값
            $0.currentQuery = .init()  // 초기 쿼리
        }

        await store.receive(.inside(.recievedPokemons(result: .success(mockPokemonList), isAppend: false))) {
            $0.isLoading = false
            $0.pokemons = mockPokemonList
            $0.pokemonCellStates = IdentifiedArray(uniqueElements: mockPokemonList.pokemons.map {
                PokemonCellFeature.State(pokemon: $0)
            })
        }
    }
}
