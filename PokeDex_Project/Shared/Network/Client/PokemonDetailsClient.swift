//
//  VarietiesApiService.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import ComposableArchitecture
import Foundation

/// 포켓몬, 리전폼, 진화트리 (상세화면) APIClient
struct PokemonDetailsClient {
    typealias ReturnPokemon = @Sendable (_ id: Int) async throws -> Pokemon
    typealias ReturnVarieties = @Sendable (_ name:String) async throws -> Varieties
    typealias ReturnEvolution = @Sendable (_ num: Int) async throws -> EvolutionTo
    
    /// 단일 포켓몬 요청
    var fetchPokemon: ReturnPokemon
    /// 다른 모습 요청
    var fetchVariety: ReturnVarieties
    /// 진화트리 요청
    var fetchEvolution: ReturnEvolution
}

// MARK: - 각 요청에 해당하는 의존성 키 주입
extension PokemonDetailsClient: DependencyKey {
    static var liveValue: PokemonDetailsClient {
        // 포켓몬 요청
        let pokemon: ReturnPokemon = { id in
            let request = PokemonDetailsRouter.pokemon(id: id).makeURLRequest()
            return try await URLSession.shared.requestDecoding(Response<Pokemon>.self, urlRequest: request).data
        }
        // 다른 모습 요청
        let variety: ReturnVarieties = { name in
            let request = PokemonDetailsRouter.variety(name: name).makeURLRequest()
            return try await URLSession.shared.requestDecoding(Response<Varieties>.self, urlRequest: request).data
        }
        // 진화트리 요청
        let evolution: ReturnEvolution = { num in
            let request = PokemonDetailsRouter.evolutuon(num: num).makeURLRequest()
            return try await URLSession.shared.requestDecoding(Response<EvolutionTo>.self, urlRequest: request).data
        }
        // MARK: - 반환
        return PokemonDetailsClient(fetchPokemon: pokemon, fetchVariety: variety, fetchEvolution: evolution)
    }
}

// MARK: - 외부에서 접근하기 위해 의존성 값 반환
extension DependencyValues {
    var pokemonDetailsClient: PokemonDetailsClient {
        get {
            self[PokemonDetailsClient.self]
        } set {
            self[PokemonDetailsClient.self] = newValue
        }
    }
}
