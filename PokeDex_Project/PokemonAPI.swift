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
    @Published var image = [String]()
    @Published var type = String()
    @Published var type2 = [String]()
    @Published var height = Int()
    @Published var weight = Int()
    @Published var desc = [String]()
    @Published var chrac = [String]()
    @Published var hiddenChrac = [String]()
    @Published var stat = [String:Int]()
    @Published var genera = String()
    @Published var egg = [String]()
    @Published var evol = [String:String]()
    
    @Published var baby = [String:String]()   //진화트리 이름 순
    @Published var junior = [String:String]()   //진화트리 이름 순
    @Published var senior = [String:String]()   //진화트리 이름 순

    
    let num = 1
    

    
    var cancelable = Set<AnyCancellable>()
    func urlToInt(url:String)->Int{
        let url = Int(String(url.filter({$0.isNumber}).dropFirst()))!
        return url
    }
    func imageUrl(url:Int)->String{
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"
    }
    func getKoreanName(name:String) async->String{
        let name = try? await PokemonAPI().pokemonService.fetchPokemonSpecies(name)
        return name?.names![2].name ?? ""
    }
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
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(self.num)
            if let url = species.evolutionChain?.url{   //포켓몬 진화트리 url //진화트리 검색 메서드에 필요한 id 추출
                let chain = try await PokemonAPI().evolutionService.fetchEvolutionChain(urlToInt(url: url))
                await baby[getKoreanName(name: (chain.chain?.species?.name)!)] = imageUrl(url: urlToInt(url: (chain.chain?.species?.url)!))
                if let secondChain = chain.chain?.evolvesTo{
                    for sec in secondChain{
                        await self.junior[getKoreanName(name: (sec.species?.name)!)] = imageUrl(url: urlToInt(url: (sec.species?.url)!))
                        if let third = sec.evolvesTo{
                            for thr in third{
                                await self.senior[getKoreanName(name: (thr.species?.name)!)] = imageUrl(url: urlToInt(url: (thr.species?.url)!))
                            }
                        }
                    }
                }
            }
        }

        
        PokemonAPI().pokemonService.fetchPokemonSpecies(num) { result in
            switch result {
            case .success(let pokemon):
                if let gen = pokemon.genera{
                    if gen.count != 1{
                        self.genera = pokemon.genera?[1].genus ?? ""
                        if let egg = pokemon.eggGroups{
                            for i in egg{
                                self.egg.append(i.name ?? "")
                            }
                        }
                    }
                }
                //self.type = pokemon.
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
        Task{
           let another =  try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)    //다른 모습
            if let anotherForm = another.varieties{
                for i in anotherForm{
                    self.image.append("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(urlToInt(url: (i.pokemon?.url)!)).png")
                    
                }
            }
        }
        Task{
            let species =  try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)    //다른 모습
            if let anotherForm = species.varieties{
                 for i in anotherForm{
                     let code = try await PokemonAPI().pokemonService.fetchPokemon(urlToInt(url: (i.pokemon?.url)!))
                     if let types = code.types{
                         self.type =  types.first?.type?.name ?? ""
                         self.type2.append(types.last?.type?.name ?? "")
                     }
                 }
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
