//
//  PokemonApiService.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import Foundation
import ComposableArchitecture

/// 포켓몬 APIClient
struct PokemonClient {
    typealias ReturnPokemon = @Sendable (_ id: Int) async throws -> PokemonResponse
    typealias ReturnPokemons = @Sendable (
        _ page: Int,
        _ region: String,
        _ type_1: String,
        _ type_2: String,
        _ query: String
    ) async throws -> PokemonListResponse
    
    /// 단일 포켓몬 요청
    var fetchPokemon: ReturnPokemon
    /// 포켓몬 리스트 요청
    var fetchPokemons: ReturnPokemons
}

// MARK: - 각 요청에 해당하는 의존성 키 주입
extension PokemonClient: DependencyKey {
    static var liveValue: PokemonClient {
        let pokemon: ReturnPokemon = { id in
            let request = PokemonRouter.pokemon(id: id).makeURLRequest()
            return try await URLSession.shared.requestDecoding(PokemonResponse.self, urlRequest: request)
        }
        let pokemons: ReturnPokemons = { page, region, type_1, type_2, query in
            let request = PokemonRouter.pokemons(page: page, region: region, type_1: type_1, type_2: type_2, query: query).makeURLRequest()
            return try await URLSession.shared.requestDecoding(PokemonListResponse.self, urlRequest: request)
        }
        return PokemonClient(fetchPokemon: pokemon, fetchPokemons: pokemons)
    }
}

// MARK: - 외부에서 접근하기 위해 의존성 값 반환
extension DependencyValues {
    var pokemonClient: PokemonClient {
        get {
            self[PokemonClient.self]
        } set {
            self[PokemonClient.self] = newValue
        }
    }
}
