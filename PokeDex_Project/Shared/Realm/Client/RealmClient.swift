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
    typealias DeletePokemon = @Sendable (_ num: Int) async throws -> Void
    typealias DeleteAllPokemons = @Sendable () async throws -> Void
    typealias ReadIsBookmarked = @Sendable (_ num: Int) async throws -> Bool
    
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
    /// 북마크 여부 조회
    var readIsBookmarked: ReadIsBookmarked
}

extension RealmClient: DependencyKey {
    static var liveValue: RealmClient {
        return liveValues()
    }
    
    static func liveValues() -> RealmClient {
        // 컨텍스트 저장
        let storePokemon: StorePokemon = { pokemon in
            do {
                let realm = try Realm()
                try realm.write { realm.add(pokemon) }
            } catch {
                throw RealmError.storeFailed
            }
        }
        // 포켓몬 요청
        let fetchPokemon: FetchPokemon = { num in
            let realm = try Realm()
            guard let pokemonData = realm.objects(RealmObject.self).filter("num == %@", num).first else { throw RealmError.notFound }
            return RealmPokemon(
                id: pokemonData.id.stringValue,
                num: pokemonData.num,
                name: pokemonData.name,
                image: pokemonData.image,
                types: pokemonData.types.map{String($0)}
            )
        }
        // 포켓몬 리스트 요청
        let fetchPokemons: FetchPokemons = {
            let realm = try Realm()
            var pokemons:[RealmPokemon] = []
            realm.objects(RealmObject.self).forEach { data in
                pokemons.append(
                    RealmPokemon(
                        id: data.id.stringValue,
                        num: data.num,
                        name: data.name,
                        image: data.image,
                        types: data.types.map{String($0)}
                    )
                )
            }
            return pokemons
        }
        // 포켓몬 삭제
        let deletePokemon: DeletePokemon = { num in
            let realm = try Realm()
            guard let pokemon = realm
                .objects(RealmObject.self)
                .filter("num == %@", num)
                .first else { throw RealmError.notFound }
            do {
                try realm.write {
                    realm.delete(pokemon)
                }
            } catch {
                throw RealmError.deleteFailed
            }
        }
        // 포켓몬 모두 삭제
        let deleteAll: DeleteAllPokemons = {
            do {
                let realm = try Realm()
                try realm.write { realm.deleteAll() }
            } catch {
                throw RealmError.deleteFailed
            }
        }
        // 북마크 여부 조회
        let readIsBookmarked: ReadIsBookmarked = { num in
            let realm = try Realm()
            let exists = realm.objects(RealmObject.self).filter("num == %@", num).isEmpty == false
            return exists
        }
        // MARK: - 반환
        return RealmClient(
            storePokemon: storePokemon,
            fetchPokemon: fetchPokemon,
            fetchPokemons: fetchPokemons,
            deletePokemon: deletePokemon,
            deleteAllPokemons: deleteAll,
            readIsBookmarked: readIsBookmarked
        )
    }
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

