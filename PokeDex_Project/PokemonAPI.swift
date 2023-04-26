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
    @Published var type = [String]()
    @Published var type2 = [String]()
    @Published var height = Int()
    @Published var weight = Int()
    @Published var desc = [String]()
    @Published var chrac = [String]()
    @Published var hiddenChrac = String()
    @Published var stat = [String:Int]()
    @Published var genera = String()
    @Published var egg = [String]()
    @Published var evol = [String:String]()
    @Published var formName:[String] = []
    
    @Published var baby = [String:[String]]()   //진화트리 이름 순
    @Published var junior = [String:[String]]()   //진화트리 이름 순
    @Published var senior = [String:[String]]()   //진화트리 이름 순
    
    @Published var hp = [Int]()
    @Published var attack = [Int]()
    @Published var defense = [Int]()
    @Published var spAttack = [Int]()
    @Published var spDefense = [Int]()
    @Published var speed = [Int]()
    @Published var avr = [Int]()
    
    
    var first = PassthroughSubject<(),Never>()
    let num = 479
    
    
    private func urlToInt(url:String)->Int{
        let url = Int(String(url.filter({$0.isNumber}).dropFirst()))!
        return url
    }
    private func imageUrl(url:Int)->String{
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"
    }
    private func getKoreanName(name: String) async -> String {
        let name = try? await PokemonAPI().pokemonService.fetchPokemonSpecies(name)
        return name?.names![2].name ?? ""
    }
    
    
    func call() {
        Task{   //해당 이름
            let name = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            DispatchQueue.main.async {
                self.name = name.names?[2].name ?? ""
            }
            
        }
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
        Task {
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(self.num)
            if let url = species.evolutionChain?.url {
                let chain = try await PokemonAPI().evolutionService.fetchEvolutionChain(urlToInt(url: url))
                if let first = chain.chain?.species {
                    let firstSpecies = try await PokemonAPI().pokemonService.fetchPokemonSpecies(first.name ?? "")
                    if let firstVari = firstSpecies.varieties {
                        for i in firstVari {
                            let pokemon = await self.getKoreanName(name: (first.name)!)
                            DispatchQueue.main.async {
                                self.baby[pokemon,default: []].append(self.imageUrl(url: self.urlToInt(url: (i.pokemon?.url)!)))
                            }
                        }
                    }
                }
                if let secondChain = chain.chain?.evolvesTo {
                    for sec in secondChain {
                        let secondSpecies = try await PokemonAPI().pokemonService.fetchPokemonSpecies(sec.species?.name ?? "")
                        if let secondVari = secondSpecies.varieties {
                            for i in secondVari {
                                if urlToInt(url: i.pokemon?.url ?? "") != 10093{
                                    let pokemon = await getKoreanName(name: (sec.species?.name)!)
                                    DispatchQueue.main.async {
                                        self.baby[pokemon,default: []].append(self.imageUrl(url: self.urlToInt(url: (i.pokemon?.url)!)))
                                    }
                                }
                            }
                        }
                        if let third = sec.evolvesTo {
                            for thr in third {
                                let thirdSpecies = try await PokemonAPI().pokemonService.fetchPokemonSpecies(thr.species?.name ?? "")
                                if let thirdVari = thirdSpecies.varieties {
                                    for i in thirdVari {
                                        let pokemon = await getKoreanName(name: (thr.species?.name)!)
                                        DispatchQueue.main.async {
                                            self.baby[pokemon,default: []].append(self.imageUrl(url: self.urlToInt(url: (i.pokemon?.url)!)))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            if let gen = species.genera{
                if gen.count != 1{
                    DispatchQueue.main.async {
                        self.genera = species.genera?[1].genus ?? ""
                        if let egg = species.eggGroups{
                            for i in egg{
                                self.egg.append(i.name ?? "")
                            }
                        }
                    }
                }
            }
        }
        
        
        
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            if let text = species.flavorTextEntries{
                for desc in text{
                    DispatchQueue.main.async {
                        self.desc.append(desc.flavorText ?? "")
                    }
                }
            }
        }
        Task{
            let another =  try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)    //포켓몬 화면
            if let anotherForm = another.varieties{
                for i in anotherForm{
                    if urlToInt(url: i.pokemon?.url ?? "") != 10093{
                        DispatchQueue.main.async {
                            self.image.append(self.imageUrl(url: self.urlToInt(url: (i.pokemon?.url)!)))
                        }
                        let forms =  try await PokemonAPI().pokemonService.fetchPokemon(urlToInt(url: (i.pokemon?.url)!))
                        print("폼: \(urlToInt(url: (i.pokemon?.url)!))")
                        if let name = forms.forms{
                            for i in name{
                                let formName =  try await PokemonAPI().pokemonService.fetchPokemonForm(urlToInt(url: (i.url)!))
                                
                                if let korean = formName.formNames,korean.count > 1{
                                    DispatchQueue.main.async {
                                        self.formName.append(korean[1].name ?? "")
                                    }
                                }else{
                                    self.formName.append("일반")
                                }
                            }
                        }
                    }
                }
            }
        }
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            if let types2 = species.varieties{
                for i in types2{
                    let typeVari = try await PokemonAPI().pokemonService.fetchPokemon(urlToInt(url: (i.pokemon?.url)!))
                    if let def = i.isDefault{
                        if def{
                            if let types = typeVari.types{
                                for i in types{
                                    DispatchQueue.main.async {
                                        self.type.append(i.type?.name ?? "")
                                    }
                                }
                            }
                        }else{
                            if let types2 = typeVari.types{
                                for i in types2{
                                    DispatchQueue.main.async {
                                        self.type2.append(i.type?.name ?? "")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.type2 = self.filtering(arr:self.type2)
                if self.type == self.type2{
                    self.type2.removeAll()
                }
            }
            
            
        }
        Task{
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(num)
            DispatchQueue.main.async {
                self.height = pokemon.height!
                self.weight = pokemon.weight!
            }
        }
        Task{
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(num)
            if let ab = pokemon.abilities{
                for i in ab{
                    if let hidden = i.isHidden{
                        DispatchQueue.main.async {
                            if !hidden{
                                self.chrac.append(i.ability?.name ?? "")
                            }else{
                                self.hiddenChrac = i.ability?.name ?? ""
                            }
                        }
                    }
                }
            }
        }
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            
            if let sp = species.varieties{
                for i in sp{
                    if urlToInt(url: i.pokemon?.url ?? "") != 10093{
                        let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(urlToInt(url: i.pokemon?.url ?? ""))
                        if let st = pokemon.stats{
                            DispatchQueue.main.async {
                                self.hp.append(st.first?.baseStat ?? 0)
                                self.attack.append(st[1].baseStat ?? 0)
                                self.defense.append(st[2].baseStat ?? 0)
                                self.spAttack.append(st[3].baseStat ?? 0)
                                self.spDefense.append(st[4].baseStat ?? 0)
                                self.speed.append(st.last?.baseStat ?? 0)
                                self.avr.append((st.first?.baseStat)! + st[1].baseStat! + st[2].baseStat! + st[3].baseStat! + st[4].baseStat! + (st.last?.baseStat)!)
                            }
                        }
                    }
                    
                }
            }
            
        }
    }
    func filtering(arr:[String])->[String]{
        var filteredArr: [String] = []
        
        if arr.count >= 2 {
            filteredArr.append(arr[0])
            filteredArr.append(arr[1])
        }
        
        for i in stride(from: 2, to: arr.count, by: 2) {
            if arr[i] != arr[i-2] {
                filteredArr.append(arr[i])
                filteredArr.append(arr[i+1])
            }
        }
        
        if arr.count % 2 == 1 {
            filteredArr.removeLast()
        }
        
        return filteredArr
    }
    
}
