//
//  PokemonApiService.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import Foundation
import ComposableArchitecture

/// 포켓몬 리스트(메인화면) APIClient
struct PokemonListClient {
    typealias ReturnPokemons = @Sendable (
        _ page: Int,
        _ region: String,
        _ type_1: String,
        _ type_2: String,
        _ query: String
    ) async throws -> Response<PokemonList>
    
    /// 포켓몬 리스트 요청
    var fetchPokemons: ReturnPokemons
}

// MARK: - 각 요청에 해당하는 의존성 키 주입
extension PokemonListClient: DependencyKey {
    static var liveValue: PokemonListClient {
        let pokemons: ReturnPokemons = { page, region, type_1, type_2, query in
            let request = PokemonListRouter.pokemons(page: page, region: region, type_1: type_1, type_2: type_2, query: query).makeURLRequest()
            return try await URLSession.shared.requestDecoding(Response<PokemonList>.self, urlRequest: request)
        }
        return PokemonListClient(fetchPokemons: pokemons)
    }
}

// MARK: - 외부에서 접근하기 위해 의존성 값 반환
extension DependencyValues {
    var pokemonListClient: PokemonListClient {
        get {
            self[PokemonListClient.self]
        } set {
            self[PokemonListClient.self] = newValue
        }
    }
}
