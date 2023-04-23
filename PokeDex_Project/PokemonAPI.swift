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
    @Published var dexNum = [Int]()
    @Published var name = String()
    @Published var image = String()
    @Published var type = String()
    @Published var type2 = String()
    @Published var height = Int()
    @Published var weight = Int()
    @Published var desc = [String]()
    @Published var chrac = [String]()
    @Published var hiddenChrac = [String]()
    @Published var stat = [String:Int]()
    let num = 300
    var cancelable = Set<AnyCancellable>()
    
    func call() {
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(self.num)
            if let dexNum = species.pokedexNumbers{
                for i in dexNum{
                    DispatchQueue.main.async {
                        self.dexNum.append(i.entryNumber ?? 0)
                    }
                }
            }
        }

        PokemonAPI().pokemonService.fetchPokemonSpecies(num) { result in
            switch result {
            case .success(let pokemon):
                self.name = pokemon.names![2].name ?? "없음"
                //self.type = pokemon.
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        PokemonAPI().pokemonService.fetchPokemon("bulbasaur") { result in
            switch result {
            case .success(let pokemon):
                print(pokemon.order)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        PokemonAPI().pokemonService.fetchPokemonSpecies(num) { result in
            switch result {
            case .success(let pokemon):
                if let text = pokemon.flavorTextEntries{
                    for desc in text{
                        self.desc.append(desc.flavorText ?? "")
                    }
                }
                
                //                for i in pokemon.flavorTextEntries?{
                //                    self.desc.append(pokemon.flavorTextEntries?[i.endPoint].flavorText ?? "")
                //                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(num).png"
        PokemonAPI().pokemonService.fetchPokemon(num){ result in
            switch result {
            case .success(let pokemon):
                self.type = pokemon.types?.first?.type?.name ?? ""
                if pokemon.types?.first?.type?.name != pokemon.types?.last?.type?.name{
                    self.type2 = pokemon.types?.last?.type?.name ?? ""
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        PokemonAPI().pokemonService.fetchPokemon(num){ result in
            switch result {
            case .success(let pokemon):
                self.height = pokemon.height!
                self.weight = pokemon.weight!
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        PokemonAPI().pokemonService.fetchPokemon(num){ result in
            switch result {
            case .success(let pokemon):
                if let ab = pokemon.abilities{
                    for i in ab{
                        if let hidden = i.isHidden{
                            if !hidden{
                                self.chrac.append(i.ability?.name ?? "")
                            }else{
                                self.hiddenChrac.append(i.ability?.name ?? "")
                            }
                        }
                        
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        PokemonAPI().pokemonService.fetchPokemon(num){ result in
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
