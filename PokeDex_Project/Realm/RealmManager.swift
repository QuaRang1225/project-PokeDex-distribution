//
//  RealmViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation
import RealmSwift

class RealmManager{
    static let realm = try! Realm()
    static func storePokemon(pokemon:RealmObject){
        try? realm.write {
          realm.add(pokemon)
        }
    }
    static func fetchPokemon(num:Int) -> RealmPokemon{
        guard let pokemonData = realm.objects(RealmObject.self).filter("num == \(num)").first else { return RealmPokemon(id: "", num: 0, name: "", image: "", types: []) }
        return RealmPokemon(id: pokemonData.id.stringValue, num: pokemonData.num, name: pokemonData.name, image: pokemonData.image, types: pokemonData.types.map{String($0)})
    }
    static func fetchPokemons() -> [RealmPokemon]{
        var pokemons:[RealmPokemon] = []
        realm.objects(RealmObject.self).forEach { data in
            pokemons.append(RealmPokemon(id: data.id.stringValue, num: data.num, name: data.name, image: data.image, types: data.types.map{String($0)}))
        }
        return pokemons
    }
    static func deletePokemon(num: Int) {
        guard let pokemon = realm.objects(RealmObject.self).filter("num == \(num)").first else { return }
        try! realm.write {
            realm.delete(pokemon)
        }
    }
    static func deleteAll(){
        try! realm.write {
            realm.deleteAll()
        }
    }
}
