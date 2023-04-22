//
//  PokemonAPI.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/21.
//

import Foundation
import PokemonAPI
import Combine

class PokemonViewModel:ObservableObject{
    
    @Published var name = String()
    @Published var image = String()
    @Published var type = String()
    @Published var type2 = String()
    @Published var height = Int()
    @Published var weight = Int()
    @Published var desc = [String]()
    @Published var chrac = [String:Bool]()
    @Published var stat = [String:Int]()
    var cancelable = Set<AnyCancellable>()
    
    func call(){
        PokemonAPI().pokemonService.fetchPokemonSpecies(1) { result in
            switch result {
            case .success(let pokemon):
                self.name = pokemon.names![2].name ?? "없음"
                //self.type = pokemon.
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        PokemonAPI().pokemonService.fetchPokemonSpecies(1) { result in
            switch result {
            case .success(let pokemon):
                if let description = pokemon.flavorTextEntries{
                    for i in description.indices{
                        self.desc.append(pokemon.flavorTextEntries![i].flavorText ?? "")
                    }
                }
                
//                for i in 31...34{
//                    self.desc.append(pokemon.flavorTextEntries![i+8].flavorText ?? "")
//                }
                //self.type = pokemon.
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
        PokemonAPI().pokemonService.fetchPokemon(1){ result in
            switch result {
            case .success(let pokemon):
                self.type = pokemon.types?.first?.type?.name ?? ""
                self.type2 = pokemon.types?.last?.type?.name ?? ""
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        PokemonAPI().pokemonService.fetchPokemon(1){ result in
            switch result {
            case .success(let pokemon):
                self.height = pokemon.height!
                self.weight = pokemon.weight!
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        PokemonAPI().pokemonService.fetchPokemon(1){ result in
            switch result {
            case .success(let pokemon):
                if let ab = pokemon.abilities{
                    for i in ab{
                        self.chrac[i.ability?.name ?? ""] = i.isHidden
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        PokemonAPI().pokemonService.fetchPokemon(1){ result in
            switch result {
            case .success(let pokemon):
                if let st = pokemon.stats{
                    for i in st{
                        self.stat[i.stat?.name ?? ""] = i.baseStat
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
