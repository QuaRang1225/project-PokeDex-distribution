//
//  PokemonInfoViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/05/22.
//

import Foundation
import PokemonAPI

class PokemonInfoViewModel:ObservableObject{
    
    @Published var image = String()
    @Published var name = String()
    @Published var genera = String()
    @Published var height = Int()
    @Published var weight = Int()
    @Published var eggGroup = [String]()
    @Published var gender = [Double]()
    @Published var get = Int()
    @Published var char = [String:String]()
    @Published var hiddenChar = ["no":"no"]
    @Published var types = [String]()
    
    @Published var hp = [Int]()
    @Published var attack = [Int]()
    @Published var defense = [Int]()
    @Published var spAttack = [Int]()
    @Published var spDefense = [Int]()
    @Published var speed = [Int]()
    @Published var avr = [Int]()
    
    @Published var first = [String]()
    @Published var second = [String]()
    @Published var third = [String]()
    @Published var forth = [String]()
    
    @Published var firstName = [String]()
    @Published var secondName = [String]()
    @Published var thirdName = [String]()
    @Published var forthName = [String]()
    
    @Published var desc = [String]()
    
    @Published var form = [String]()
    
    private func urlToInt(url:String)->Int{
        let url = Int(String(url.filter({$0.isNumber}).dropFirst()))!
        return url
    }
    private func imageUrl(url:Int)->String{
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"
    }
    func getKoreanName(num: Int) async -> String {
        let species = try? await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
        guard let names = species?.names else { return "" }
        
        for i in names {
            guard let name = i.language?.name else { continue }
            if name == "ko" {
                return i.name ?? ""
            }
        }
        return ""
    }
    func getKoreanType(num:Int) async -> [String]{    //포켓몬 타입/한글로 변환
        var koreanType = [String]()
        let pokemon = try? await PokemonAPI().pokemonService.fetchPokemon(num)
        if let types = pokemon?.types{
            for type in types {
                let type = try? await PokemonAPI().pokemonService.fetchType(urlToInt(url: (type.type?.url)!))
                koreanType.append(type?.names![1].name ?? "")
            }
        }
        return koreanType
    }
    func reset(num:Int){
        Task{
           // let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            DispatchQueue.main.async {
                self.name = "알로라"
            }
        }
        
    }
    func getInfo(num:Int){
        
        
        
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
//            for i in species.varieties
            
            image = imageUrl(url: num)
            let name = await getKoreanName(num: num)
            let types = await getKoreanType(num: num)
            
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(num)
            
            
            DispatchQueue.main.async {  //이름,타입
                self.name = name
                self.types = types
            }
            
            
            DispatchQueue.main.async {  //키,몸무게
                self.height = pokemon.height!
                self.weight = pokemon.weight!
            }
            
            if let stat = pokemon.stats{    //스탯
                DispatchQueue.main.async {
                    self.hp.append(stat.first?.baseStat ?? 0)
                    self.attack.append(stat[1].baseStat ?? 0)
                    self.defense.append(stat[2].baseStat ?? 0)
                    self.spAttack.append(stat[3].baseStat ?? 0)
                    self.spDefense.append(stat[4].baseStat ?? 0)
                    self.speed.append(stat.last?.baseStat ?? 0)
                    self.avr.append((stat.first?.baseStat)! + stat[1].baseStat! + stat[2].baseStat! + stat[3].baseStat! + stat[4].baseStat! + (stat.last?.baseStat)!)
                }
            }
            if let text = species.flavorTextEntries{    // 도감설명
                for desc in text{
                    DispatchQueue.main.async {
                        self.desc.append(desc.flavorText ?? "")
                    }
                }
            }
            if let genera = species.genera{ //타이틀
                DispatchQueue.main.async {
                    self.genera = genera[1].genus ?? ""
                }
            }
            if let gender = species.genderRate{
                DispatchQueue.main.async {
                    if gender != -1{
                        self.gender.append((1-Double(gender)/8.0) * 100)
                        self.gender.append(Double(gender)/8.0 * 100)
                    }else{
                        self.gender.append(1.0)
                    }
                }
            }
            if let eggGroup = species.eggGroups{    //알그룹
                for egg in eggGroup{
                    let getKoreanEgg = try await PokemonAPI().pokemonService.fetchEggGroup(urlToInt(url: egg.url!))
                    DispatchQueue.main.async {
                        self.eggGroup.append(getKoreanEgg.names?[1].name ?? "")
                    }
                }
            }
            if let rate = species.captureRate{  //포획률
                DispatchQueue.main.async {
                    self.get = rate
                }
            }
            if let ability = pokemon.abilities{ //특성
                for ab in ability{
                    if let hidden = ab.isHidden{
                        if hidden{
                            let getKoreanAbility = try await PokemonAPI().pokemonService.fetchAbility(urlToInt(url: ab.ability?.url ?? ""))
                            if let getKor = getKoreanAbility.flavorTextEntries{
                                for i in getKor{
                                    if i.language?.name == "ko"{
                                        DispatchQueue.main.async {
                                            self.hiddenChar.removeValue(forKey: "no")
                                            self.hiddenChar[getKoreanAbility.names?[1].name ?? ""] = i.flavorText
                                        }
                                    }
                                }
                            }
                        }else{
                            let getKoreanAbility = try await PokemonAPI().pokemonService.fetchAbility(urlToInt(url: ab.ability?.url ?? ""))
                            if let getKor = getKoreanAbility.flavorTextEntries{
                                for i in getKor{
                                    if i.language?.name == "ko"{
                                        DispatchQueue.main.async {
                                            self.char[getKoreanAbility.names?[1].name ?? ""] = i.flavorText
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if let chain = species.evolutionChain?.url{     //진화트리
                let evolChain = try await PokemonAPI().evolutionService.fetchEvolutionChain(urlToInt(url: chain))   //체인
                let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(urlToInt(url: evolChain.chain?.species?.url ?? ""))
                if let name = species.names{
                    for kor in name{
                        if let korName =  kor.language?.name,korName == "ko"{
                            DispatchQueue.main.async {
                                self.firstName.append(kor.name ?? "")
                                self.first.append(self.imageUrl(url: self.urlToInt(url: evolChain.chain?.species?.url ?? "")))
                            }
                            if let vari = species.varieties{
                                for pokemon in vari{
                                    DispatchQueue.main.async {
                                        if let name = pokemon.pokemon?.name,name.hasSuffix("galar") || name.hasSuffix("alola") || name.contains("mega"){
                                            if name.hasSuffix("galar"){
                                                self.firstName.append(kor.name! + "(가라르)")
                                            }else if name.hasSuffix("alola"){
                                                self.firstName.append(kor.name! + "(알로라)" )
                                            }else if name.contains("mega"){
                                                if name.hasSuffix("mega-y"){
                                                    self.forthName.append("메가" + kor.name! + "Y")
                                                }
                                                if name.hasSuffix("mega-x"){
                                                    self.forthName.append("메가" + kor.name! + "X")
                                                }else{
                                                    self.forthName.append("메가" + kor.name!)
                                                }
                                                self.forthName = self.forthName.uniqued()
                                                self.forth.append(self.imageUrl(url: self.urlToInt(url: pokemon.pokemon?.url ?? "")))
                                            }
                                            self.first.append(self.imageUrl(url: self.urlToInt(url: pokemon.pokemon?.url ?? "")))
                                            self.firstName = self.firstName.uniqued()
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
               
                if let secondEvo = evolChain.chain?.evolvesTo{
                    for second in secondEvo{
                        let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(urlToInt(url: second.species?.url ?? ""))
                        if let name = species.names{
                            for kor in name{
                                if let korName =  kor.language?.name,korName == "ko"{
                                    DispatchQueue.main.async {
                                        self.secondName.append(kor.name ?? "")
                                        self.second.append(self.imageUrl(url: self.urlToInt(url: second.species?.url ?? "")))
                                    }
                                    if let vari = species.varieties{
                                        for pokemon in vari{
                                            DispatchQueue.main.async{
                                                if let name = pokemon.pokemon?.name,name.hasSuffix("galar") || name.hasSuffix("alola") || name.contains("mega"){
                                                    if name.hasSuffix("galar"){
                                                        self.secondName.append(kor.name! + "(가라르)")
                                                    }else if name.hasSuffix("alola"){
                                                        self.secondName.append(kor.name! + "(알로라)" )
                                                    }else if name.contains("mega"){
                                                        if name.hasSuffix("mega-y"){
                                                            self.forthName.append("메가" + kor.name! + "Y")
                                                        }
                                                        if name.hasSuffix("mega-x"){
                                                            self.forthName.append("메가" + kor.name! + "X")
                                                        }else{
                                                            self.forthName.append("메가" + kor.name!)
                                                            
                                                        }
                                                        self.forthName = self.forthName.uniqued()
                                                        self.forth.append(self.imageUrl(url: self.urlToInt(url: pokemon.pokemon?.url ?? "")))
                                                    }
                                                    self.second.append(self.imageUrl(url: self.urlToInt(url: pokemon.pokemon?.url ?? "")))
                                                    self.secondName = self.secondName.uniqued()
                                                }
                                                
                                            }
                                        }
                                    }
                                   
                                }
                            }
                        }
                       
                        if let thirdEvo = second.evolvesTo{
                            for third in thirdEvo{
                                let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(urlToInt(url: third.species?.url ?? ""))
                                if let name = species.names{
                                    for kor in name{
                                        if let korName =  kor.language?.name,korName == "ko"{
                                            DispatchQueue.main.async {
                                                self.thirdName.append(kor.name ?? "")
                                                self.third.append(self.imageUrl(url: self.urlToInt(url: third.species?.url ?? "")))
                                            }
                                            if let vari = species.varieties{
                                                for pokemon in vari{
                                                    DispatchQueue.main.async {
                                                        if let name = pokemon.pokemon?.name,name.hasSuffix("galar") || name.hasSuffix("alola") || name.contains("mega"){
                                                            if name.hasSuffix("galar"){
                                                                self.thirdName.append(kor.name! + "(가라르)")
                                                            }else if name.hasSuffix("alola"){
                                                                self.thirdName.append(kor.name! + "(알로라)" )
                                                            }else if name.contains("mega"){
                                                                if name.hasSuffix("mega-y"){
                                                                    self.forthName.append("메가" + kor.name! + "Y")
                                                                }
                                                                if name.hasSuffix("mega-x"){
                                                                    self.forthName.append("메가" + kor.name! + "X")
                                                                }else{
                                                                    self.forthName.append("메가" + kor.name!)
                                                                }
                                                                self.forthName = self.forthName.uniqued()
                                                                self.forth.append(self.imageUrl(url: self.urlToInt(url: pokemon.pokemon?.url ?? "")))
                                                            }
                                                            self.third.append(self.imageUrl(url: self.urlToInt(url: pokemon.pokemon?.url ?? "")))
                                                            self.thirdName = self.thirdName.uniqued()
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
