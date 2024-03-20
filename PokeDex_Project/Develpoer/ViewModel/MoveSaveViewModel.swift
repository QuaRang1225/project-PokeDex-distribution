//
//  MovieSaveViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/08/19.
//

import Foundation
import PokemonAPI
//import FirebaseFirestoreSwift
//import FirebaseFirestore


class MoveSaveViewModel:ObservableObject{
    
    
    
    @MainActor
    func getMoveList(num:Int) {
        Task{
            let moveResults = try await PokemonAPI().moveService.fetchMove(num)
            let type = try await PokemonAPI().pokemonService.fetchType(moveResults.type?.name ?? "")
            
            var moveName = ""
            var moveDes = ""
            var damageClass = ""
            
            if let moveListresult = moveResults.names{
                let korName = moveListresult.first(where: {$0.language?.name == "ko"})
                moveName = korName?.name ?? ""
            }
            if let moveDescriptions = moveResults.flavorTextEntries{
                let korDes =  moveDescriptions.first(where: {$0.language?.name == "ko"})
                moveDes = korDes?.flavorText ?? ""
            }
            
            
            
            switch moveResults.damageClass?.name{
            case "physical":
                damageClass = "물리"
            case "special":
                damageClass = "특수"
            case "status":
                damageClass = "변화"
            case .none:
                return
            case .some(_):
                return
            }
            
            let data:[String : Any] = [
                "id":num,
                "name":moveName,
                "description":moveDes,
                "power":moveResults.power ?? 0,
                "pp":moveResults.pp ?? 0,
                "accuracy":moveResults.accuracy ?? 0,
                "type":type.names?.first(where: {$0.language?.name == "ko"})?.name ?? "",
                "damge":damageClass
            ]
            
//            try await Firestore.firestore().collection("Move").document("\(num)").setData(data)
        }
    }
    
    
    
    @MainActor
    func getItemList() {
        
        Task{
            let items = try await PokemonAPI().itemService.fetchItemList(paginationState: PaginationState.initial(pageLimit: 2050))
            
            if let results = items.results{
                for result in results {
                    
                    let num = result.url?.urlToInt() ?? 0
                    do{
                        let item = try await PokemonAPI().itemService.fetchItem(num)
                        
                        let data:[String:Any] = [
                            "id":num,
                            "name":item.names?.first(where: {$0.language?.name == "ko"})?.name ?? "",
                            "description":item.flavorTextEntries?.first(where: {$0.language?.name == "ko"})?.text ?? "",
                            "coast":item.cost ?? 0,
                            "sprites":item.sprites?.default ?? ""
                        ]
//                        try await Firestore.firestore().collection("Items").document("\(num)").setData(data)
                        
                    }catch{}
                }
            }
            
        }
        
    }
    
    func getMove() async{
        for i in 1...900{
            await getMoveList(num:i)
        }
        for i in 10001...10018{
            await getMoveList(num:i)
        }
    }
    
    //    func getPokeInfo() async throws{
    //
    //        let pokemon = try await PokemonAPI().pokemonService.fetchPokemonList(paginationState: PaginationState.initial(pageLimit: 1281))
    //        if let results = pokemon.results{
    //            for i in results{
    //                let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(i.url?.urlToInt() ?? 0)
    //            }
    //        }
    //
    //    }
    @MainActor
    func getSpecies(num:Int) {  //폼이 바뀌어도 바뀌지 않을 정보들
        
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            
            var desc:[String] = []
            var genera = ""
            var dexNum = num    //도감번호
            var name = await getKoreanName(num: num)    //이름
            var gender:[Double] = []
            var eggGroup:[String] = []
            var get = species.captureRate ?? 0  //포획률
            
           
            
            
            // 도감설명
            //----------------------------------------------
            if let text = species.flavorTextEntries,!text.isEmpty{
                desc = Array(Set(text.filter({$0.language?.name == "ko"}).map({$0.flavorText?.replacingOccurrences(of: "\n", with: " ") ?? ""})))
            }
            
            
            //타이틀 - 이상해씨:씨앗포켓몬
            //----------------------------------------------
            if let generas = species.genera{
                if generas.contains(where: {$0.language?.name == "ko"}){
                    genera = generas.filter({$0.language?.name == "ko"}).first?.genus ?? ""
                }else{
                    genera = generas.filter({$0.language?.name == "en"}).first?.genus ?? ""
                }
            }
            
            //성비
            //----------------------------------------------
            if let genders = species.genderRate{
                if genders != -1{
                    gender.append((1 - Double(genders)/8.0) * 100)
                    gender.append(Double(genders)/8.0 * 100)
                }else{
                    gender.append(1.0)
                }
            }
            
            //알그룹
            //----------------------------------------------
            if let eggGroups = species.eggGroups{
                for egg in eggGroups{
                    let getKoreanEgg = try await PokemonAPI().pokemonService.fetchEggGroup(urlToInt(url: egg.url!))
                    eggGroup.append(getKoreanEgg.names?[1].name ?? "")
                }
            }
            
            var first:PokemonDetail?
            var second:[PokemonDetail] = []
            var third:[PokemonDetail] = []
            
            //진화트리
            //----------------------------------------------
            let evolutionChain = try await PokemonAPI().evolutionService.fetchEvolutionChain(urlToInt(url: species.evolutionChain?.url ?? ""))
            if let chain = evolutionChain.chain{
                first = PokemonDetail(id: urlToInt(url: chain.species?.url ?? ""), name: await getKoreanNameString(name: chain.species?.name ?? ""), sprite: imageUrl(url: urlToInt(url: chain.species?.url ?? "")))
            }
            if let evolesTo = evolutionChain.chain?.evolvesTo{
                for to in evolesTo {
                    var secondDetail:[String] = []
                    
                    if let detail = to.evolutionDetails{
                        for det in detail{
                            let evloution = try await getEvolutionTree(name: to.species?.name ?? "",det: det)
                            secondDetail.append(evloution)
                        }
                        second.append(PokemonDetail(id: urlToInt(url: to.species?.url ?? ""), name: await getKoreanNameString(name: to.species?.name ?? ""), sprite: imageUrl(url: urlToInt(url: to.species?.url ?? "")),evolDetail: secondDetail ))
                    }
                    
                    if let evolTo = to.evolvesTo{
                        for to in evolTo{
                            var thirdDetail:[String] = []
                            if let detail = to.evolutionDetails{
                                for det in detail{
                                    let evolution = try await getEvolutionTree(name: to.species?.name ?? "",det: det)
                                    thirdDetail.append(evolution)
                                }
                            }
                            third.append(PokemonDetail(id: urlToInt(url: to.species?.url ?? ""), name: await getKoreanNameString(name: to.species?.name ?? ""), sprite: imageUrl(url: urlToInt(url: to.species?.url ?? "")),evolDetail: thirdDetail ))
                        }
                    }
                }
            }
            print(first ?? PokemonDetail(id: 0, name: "", sprite: ""))
            print(second)
            print(third)
            
            print(desc)
            print(genera)
            print(dexNum)
            print(name)
            print(gender)
            print(eggGroup)
            print(get)
            //            print("\(heldItem.names?.first(where: {$0.language?.name == "ko"})?.name ?? "")을(를) 지닌 상태로 ")
            
        }
    }
    @MainActor
    func getPokemon(num:Int){
        
        Task{
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(num)
            
            var artworkImage = imageUrl(url: num)   //이미지
            var types = await getKoreanType(num: num)  //타입
            var height = Double(pokemon.height!)/10.0   //키
            var weight = Double(pokemon.weight!)/10.0   //몸무게
            
            
            //스탯
            //----------------------------------------------
            var stats:[String:Int] = [:]
            
            let statsName = ["HP","공격","방어","특공","특방","스피드"]
            let baseStats = pokemon.stats?.map({$0.baseStat ?? 0})
            
            for (index,key) in statsName.enumerated(){
                stats[key] = baseStats?[index]
            }
            
            
            //특성
            //----------------------------------------------
            var hiddenAbility:[String:String] = [:]
            if let hidden = pokemon.abilities?.filter({$0.isHidden!}).map({$0.ability?.name ?? ""}){
                for abilityCode in hidden{
                    let hiddenAb = try await PokemonAPI().pokemonService.fetchAbility(abilityCode)
                    hiddenAbility[hiddenAb.names?.first(where: {$0.language?.name == "ko"})?.name ?? ""] = hiddenAb.flavorTextEntries?.filter({$0.language?.name == "ko"}).last?.flavorText?.replacingOccurrences(of: "\n", with: " ")
                }
            }
            var ability:[String:String] = [:]
            if let filteringAbility = pokemon.abilities?.filter({!$0.isHidden!}).map({$0.ability?.name ?? ""}){
                for abilityCode in filteringAbility{
                    let ab = try await PokemonAPI().pokemonService.fetchAbility(abilityCode)
                    ability[ab.names?.first(where: {$0.language?.name == "ko"})?.name ?? ""] = ab.flavorTextEntries?.filter({$0.language?.name == "ko"}).last?.flavorText?.replacingOccurrences(of: "\n", with: " ")
                }
            }
            
            
            
            
            
                        print(artworkImage)
                        print(types)
                        print(height)
                        print(stats)
                        print(weight)
                        print(ability)
                        print(hiddenAbility)
            
            //            let item = try await PokemonAPI().itemService.fetchItem(84)
            //            print(item.name)
            
            //            if num == 10143{    //아르세우스
            //                image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/10143.png"
            //            }else{
            //                image = imageUrl(url: num)
            //            }
            //            if num == 10190{    //무한다이노
            //                self.weight =  4780
            //            }else{
            //                self.weight = pokemon.weight!   //몸무게
            //            }
            
            
            
        }
        
    }
    
    
    
    func urlToInt(url:String)->Int{ //포켓몬 이미지를 얻기 위한 url에서 코드 추출
        let url = Int(String(url.filter({$0.isNumber}).dropFirst()))!
        return url
    }
    private func imageUrl(url:Int)->String{ //이미지 url저장
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"
    }
    //
    func getKoreanName(num: Int) async -> String {  //포켓몬 코드 -> 한글명(이름)
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
    func getKoreanNameString(name: String) async -> String {  //포켓몬 코드 -> 한글명(이름)
        let species = try? await PokemonAPI().pokemonService.fetchPokemonSpecies(name)
        guard let names = species?.names else { return "" }
        
        for i in names {
            guard let name = i.language?.name else { continue }
            if name == "ko" {
                return i.name ?? ""
            }
        }
        return ""
    }
    
    func getKoreanType(num:Int) async -> [String]{    //포켓몬 코드 -> 한글명(타입)
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
    func getEvolutionTree(name:String,det:PKMEvolutionDetail)async throws-> String{
        
        
        
        var status = ""
        if let gender = det.gender{ //성별
            switch gender{
            case 1:status.append(contentsOf:"암컷")
            case 2:status.append(contentsOf:"수컷")
            default: break
            }
        }
        if let heldItem = det.heldItem{    //지닌아이템
            //                let heldItem = try await PokemonAPI().itemService.fetchItem(heldItem.name ?? "")
            //                status.append(contentsOf:"\(heldItem.names?.first(where: {$0.language?.name == "ko"})?.name ?? "")을(를) 지닌 상태로 ")
            status.append(contentsOf: "\(ItemFilter.allCases.first(where: {$0.rawValue == heldItem.name})?.name ?? "")을(를) 지닌 상태로 ") //임시
        }
        if let item = det.item{
            let item = try await PokemonAPI().itemService.fetchItem(item.name ?? "")
            status.append(contentsOf:"\(item.names?.first(where: {$0.language?.name == "ko"})?.name ?? "") ")
        }
        if let knownMove = det.knownMove{
            let skill = try await PokemonAPI().moveService.fetchMove(knownMove.name ?? "")
            status.append(contentsOf:"\(skill.names?.first(where: {$0.language?.name == "ko"})?.name ?? "")을(를) 배운 상태로 ")
        }
        if let knownMoveType = det.knownMoveType{
            let type = try await PokemonAPI().pokemonService.fetchType(knownMoveType.name ?? "")
            status.append(contentsOf:"\(type.names?.first(where: {$0.language?.name == "ko"})?.name ?? "")타입 기술을 배운 상태로 ")
        }
        if let location = det.location{
            let loc = try await PokemonAPI().locationService.fetchLocation(urlToInt(url:location.url ?? ""))
            status.append(contentsOf:"\(LocationFilter.allCases.first(where: {$0.region == loc.region?.name})?.name.replacingOccurrences(of: "도감", with: "지방") ?? ""): \(loc.name ?? "")에서 ")
        }
        if let minAffection = det.minAffection{
            status.append(contentsOf:"친밀도 \(minAffection)인 상태로 ")
        }
        if let minBeauty = det.minBeauty{
            status.append(contentsOf:"아름다움 \(minBeauty)인 상태로 ")
        }
        if let minLevel = det.minLevel{
            status.append(contentsOf:"Lv.\(minLevel)")
        }
        if let minHappy = det.minHappiness{
            status.append(contentsOf:"친밀도 \(minHappy)인 상태로 ")
        }
        if let rain = det.needsOverworldRain,rain{
            status.append(contentsOf:"비가 올때 ")
        }
        if let partySpecies = det.partySpecies{
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemonSpecies(partySpecies.name ?? "")
            status.append(contentsOf:"지닌 포켓몬에 \(String(describing: pokemon.names?.first(where: {$0.language?.name == "ko"})?.name ?? ""))이(가) 있을 때 ")
        }
        if let partyType = det.partyType{
            let type = try await PokemonAPI().pokemonService.fetchType(partyType.name ?? "")
            status.append(contentsOf:"지닌 포켓몬에 \(String(describing: type.names?.first(where: {$0.language?.name == "ko"})?.name ?? ""))타입 포켓몬이 있을 때 ")
        }
        if let physical = det.relativePhysicalStats{
            switch physical{
            case 1: status.append(contentsOf:"공격이 방어보다 높을 때 ")
            case -1: status.append(contentsOf:"방어가 공격보다 높을 때 ")
            case 0: status.append(contentsOf:"공격과 방어가 같을 때 ")
            default:break
            }
        }
        if let day = det.timeOfDay{
            switch day{
            case "day": status.append(contentsOf:"낮에 ")
            case "night": status.append(contentsOf:"밤에 ")
            case "dusk": status.append(contentsOf:"황혼에 ")
            default: break
            }
        }
        if let trade = det.tradeSpecies{
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemonSpecies(trade.name ?? "")
            status.append(contentsOf:"\(String(describing: pokemon.names?.first(where: {$0.language?.name == "ko"})?.name ?? ""))외(과) ")
        }
        if let turn = det.turnUpsideDown,turn{
            status.append(contentsOf:"DS를 뒤집을 상태로 ")
        }
        if let trigger = det.trigger?.name, trigger == "other"{
            status.append(contentsOf:OtherFiler.allCases.first(where: {$0.rawValue == name})?.evol ?? "")
        }else{
            status.append(contentsOf:EvolutionFilter.allCases.first(where: {$0.rawValue == det.trigger?.name})?.description ?? "")
        }
        
        return status
    }
}

extension String{
    func urlToInt()->Int{ //포켓몬 이미지를 얻기 위한 url에서 코드 추출
        let url = Int(String(self.filter({$0.isNumber}).dropFirst()))!
        return url
    }
}
