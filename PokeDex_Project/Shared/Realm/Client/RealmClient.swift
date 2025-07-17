//
//  RealmViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation
import RealmSwift
import ComposableArchitecture
 
/// RealmDB에서 데이터 요청
struct RealmClient {
    typealias StorePokemon = @Sendable (_ pokemon: RealmObject) async throws -> Void
    typealias FetchPokemon = @Sendable (_ num: Int) async throws -> RealmPokemon
    typealias FetchPokemons = @Sendable () async throws -> [RealmPokemon]
    typealias DeletePokemon = @Sendable (_ pokemon: RealmObject) async throws -> Void
    typealias DeleteAllPokemons = @Sendable () async throws -> Void
    
    /// 컨텍스트 저장
    var storePokemon: StorePokemon
    /// 단일 포켓몬 요청
    var fetchPokemon: FetchPokemon
    /// 포켓몬 리스트 요청
    var fetchPokemons: FetchPokemons
    /// 포켓몬 삭제
    var deletePokemon: DeletePokemon
    /// 포켓몬 전체삭제
    var deleteAllPokemons: DeleteAllPokemons
}

extension RealmClient: DependencyKey {
    static func liveValue(realm: Realm = try! Realm()) -> RealmClient {
        let storePokemon: StorePokemon = { pokemon in
            try! realm.write { realm.add(pokemon) }
        }
        let fetchPokemon: FetchPokemon = { num in
            guard let pokemonData = realm.objects(RealmObject.self).filter("num == \(num)").first else { throw RealmError.notFound }
            return RealmPokemon(id: pokemonData.id.stringValue, num: pokemonData.num, name: pokemonData.name, image: pokemonData.image, types: pokemonData.types.map{String($0)})
        }
        let fetchPokemons: FetchPokemons = {
            var pokemons:[RealmPokemon] = []
            realm.objects(RealmObject.self).forEach { data in
                pokemons.append(RealmPokemon(id: data.id.stringValue, num: data.num, name: data.name, image: data.image, types: data.types.map{String($0)}))
            }
            return pokemons
        }
        let deletePokemon: DeletePokemon = { num in
            guard let pokemon = realm.objects(RealmObject.self).filter("num == \(num)").first else { throw RealmError.deleteFailed }
            try! realm.write {
                realm.delete(pokemon)
            }
        }
        let deleteAll: DeleteAllPokemons = {
            try! realm.write { realm.deleteAll() }
        }
        return RealmClient(
            storePokemon: storePokemon,
            fetchPokemon: fetchPokemon,
            fetchPokemons: fetchPokemons,
            deletePokemon: deletePokemon,
            deleteAllPokemons: deleteAll
        )
    }
    static var liveValue: RealmClient { liveValue() }
}

extension DependencyValues {
    var realmClient: RealmClient {
        get {
            self[RealmClient.self]
        } set {
            self[RealmClient.self] = newValue
        }
    }
}

