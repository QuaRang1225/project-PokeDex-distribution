//
//  PokemonInfoViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/05/22.
//

import Foundation
import PokemonAPI

class PokemonInfoViewModel:ObservableObject{
    
    
    @Published var dexNum = Int()
    @Published var image = String() //이미지
    @Published var name = String()  //이름
    @Published var genera = String()    //타이틀
    @Published var height = Int()   //키
    @Published var weight = Int()   //몸무게
    @Published var eggGroup = [String]()    //알그룹
    @Published var gender = [Double]()  //성비
    @Published var get = Int()  //포획률
    
    @Published var firstChar = String()   //특성
    @Published var firstCharDesc = String()    //특성 설명
    @Published var secondChar = String()   //특성
    @Published var secondCharDesc = String()    //특성 설명
    @Published var hiddenChar = String()  //숨겨진 특성
    @Published var hiddenCharDesc = String() //숨겨진특성 설명
    
    @Published var types = [String]()   //타입
    
    //스탯
    @Published var hp = [Int]()
    @Published var attack = [Int]()
    @Published var defense = [Int]()
    @Published var spAttack = [Int]()
    @Published var spDefense = [Int]()
    @Published var speed = [Int]()
    @Published var avr = [Int]()
    
    //진화트리 - 포켓몬 이미지
    @Published var first = [String]()
    @Published var second = [String]()
    @Published var third = [String]()
    
    //진화트리 - 포켓몬 이름
    @Published var firstName = [String]()
    @Published var secondName = [String]()
    @Published var thirdName = [String]()
    
    @Published var desc = [String]()    //도감설명
    
    @Published var isRegion = [Int]()
    @Published var isRegionName = [String]()
    
    @Published var isForm = [String]()
    @Published var isFormname = [String]()
    
    @Published var mega = [String]()
    
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
    
    @MainActor
    func getEvol(num:Int){
        
        self.first.removeAll()
        self.firstName.removeAll()
        self.second.removeAll()
        self.secondName.removeAll()
        self.third.removeAll()
        self.thirdName.removeAll()
        
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            if let chain = species.evolutionChain?.url{     //진화트리
                let evolChain = try await PokemonAPI().evolutionService.fetchEvolutionChain(urlToInt(url: chain))   //체인
                let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(urlToInt(url: evolChain.chain?.species?.url ?? ""))
                if let name = species.names{
                    for kor in name{
                        if let korName =  kor.language?.name,korName == "ko"{
                                self.firstName.append(kor.name ?? "")
                                self.first.append(self.imageUrl(url: self.urlToInt(url: evolChain.chain?.species?.url ?? "")))
                            
                        }
                    }
                }
                
                if let secondEvo = evolChain.chain?.evolvesTo{
                    for second in secondEvo{
//                        if let details = second.evolutionDetails{
//                            for s in details{
//                                print(s)
//                            }
//                        }
                        
                        
                        
                        let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(urlToInt(url: second.species?.url ?? ""))
                        if let name = species.names{
                            for kor in name{
                                if let korName =  kor.language?.name,korName == "ko"{
                                    DispatchQueue.main.async {
                                        self.secondName.append(kor.name ?? "")
                                        self.second.append(self.imageUrl(url: self.urlToInt(url: second.species?.url ?? "")))
                                    }
                                }
                            }
                        }
                        
                        if let thirdEvo = second.evolvesTo{
                            for third in thirdEvo{
//                                if let details = third.evolutionDetails{
//                                    for s in details{
////                                        print(s.item.)
//                                    }
//                                }
                                let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(urlToInt(url: third.species?.url ?? ""))
                                if let name = species.names{
                                    for kor in name{
                                        if let korName =  kor.language?.name,korName == "ko"{
                                            DispatchQueue.main.async {
                                                self.thirdName.append(kor.name ?? "")
                                                self.third.append(self.imageUrl(url: self.urlToInt(url: third.species?.url ?? "")))
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
    @MainActor
    func getSpecies(num:Int){  //포켓몬 정보 요청
        

        self.name.removeAll()
        self.desc.removeAll()
        self.genera.removeAll()
        self.gender.removeAll()
        self.eggGroup.removeAll()
        
        
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            let name = await getKoreanName(num: num)
            self.dexNum = num
            self.name = name    //이름
           
            
 
            if let text = species.flavorTextEntries,!text.isEmpty{    // 도감설명
                for desc in text{
                    if desc.language?.name == "ko"{
                        self.desc.append(desc.flavorText ?? "")
                    }
                }
            }
            if let genera = species.genera{         //타이틀 - 이상해씨:씨앗포켓몬
                if genera.contains(where: {$0.language?.name == "ko"}){
                    for gen in genera{
                        if gen.language?.name == "ko"{
                            self.genera = gen.genus ?? ""
                        }
                    }
                }else{
                    for gen in genera{
                        if gen.language?.name == "en"{
                            self.genera = gen.genus ?? ""
                        }
                    }
                }
            }
            if let gender = species.genderRate{     //성비
                if gender != -1{
                    self.gender.append((1-Double(gender)/8.0) * 100)
                    self.gender.append(Double(gender)/8.0 * 100)
                }else{
                    self.gender.append(1.0)
                }
            }
            if let eggGroup = species.eggGroups{    //알그룹
                for egg in eggGroup{
                    let getKoreanEgg = try await PokemonAPI().pokemonService.fetchEggGroup(urlToInt(url: egg.url!))
                    self.eggGroup.append(getKoreanEgg.names?[1].name ?? "")
                }
            }
            if let rate = species.captureRate{  //포획률
                self.get = rate
            }
            
        }
    }
    @MainActor
    func getPokeon(num:Int){
        
        
        self.hp.removeAll()
        self.attack.removeAll()
        self.defense.removeAll()
        self.spAttack.removeAll()
        self.spDefense.removeAll()
        self.speed.removeAll()
        self.avr.removeAll()
        
        
        if num == 10143{
            image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/10143.png"
        }else{
            image = imageUrl(url: num)
        }
        
        
        Task{
            
            let types = await getKoreanType(num: num)
            self.types = types  //타입
            
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(num)
            self.height = pokemon.height!   //키
            
            
            if num == 10190{
                self.weight =  4780
            }else{
                self.weight = pokemon.weight!   //몸무게
            }
            
            
            if let stat = pokemon.stats{    //스탯
                self.hp.append(stat.first?.baseStat ?? 0)
                self.attack.append(stat[1].baseStat ?? 0)
                self.defense.append(stat[2].baseStat ?? 0)
                self.spAttack.append(stat[3].baseStat ?? 0)
                self.spDefense.append(stat[4].baseStat ?? 0)
                self.speed.append(stat.last?.baseStat ?? 0)
                self.avr.append((stat.first?.baseStat)! + stat[1].baseStat! + stat[2].baseStat! + stat[3].baseStat! + stat[4].baseStat! + (stat.last?.baseStat)!)
            }
            if let ability = pokemon.abilities{ //특성
                for ab in ability{
                    if let hidden = ab.isHidden{
                        if hidden{
                            let getKoreanAbility = try await PokemonAPI().pokemonService.fetchAbility(urlToInt(url: ab.ability?.url ?? ""))
                            if let names = getKoreanAbility.names{
                                if names.contains(where: {$0.language?.name == "ko"}){
                                    for name in names{
                                        if name.language?.name == "ko"{
                                            self.hiddenChar = name.name ?? ""
                                        }
                                    }
                                }else{
                                    for name in names{
                                        if name.language?.name == "en"{
                                            self.hiddenChar = name.name ?? ""
                                        }
                                    }
                                }
                                
                            }
                            if let getKor = getKoreanAbility.flavorTextEntries{
                                if getKor.isEmpty{
                                    self.hiddenCharDesc = "...연구결과 손실..."
                                }else{
                                    if getKor.contains(where: {$0.language?.name == "ko"}){
                                        for name in getKor{
                                            if name.language?.name == "ko"{
                                                self.hiddenCharDesc = name.flavorText ?? ""
                                            }
                                        }
                                    }else{
                                        for name in getKor{
                                            if name.language?.name == "en"{
                                                self.hiddenCharDesc = name.flavorText ?? ""
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            if ab.slot == 1{
                                let getKoreanAbility = try await PokemonAPI().pokemonService.fetchAbility(urlToInt(url: ab.ability?.url ?? ""))
                               
                                if  let names = getKoreanAbility.names{
                                    if names.contains(where: {$0.language?.name == "ko"}){
                                        for name in names{
                                            if name.language?.name == "ko"{
                                                self.firstChar = name.name ?? ""
                                            }
                                        }
                                    }else{
                                        for name in names{
                                            if name.language?.name == "en"{
                                                self.firstChar = name.name ?? ""
                                            }
                                        }
                                    }
                                }
                                if let getKor = getKoreanAbility.flavorTextEntries{
                                    if getKor.isEmpty{
                                        self.firstCharDesc = "...연구결과 손실..."
                                    }else{
                                        if getKor.contains(where: {$0.language?.name == "ko"}){
                                            for name in getKor{
                                                if name.language?.name == "ko"{
                                                    self.firstCharDesc = name.flavorText ?? ""
                                                }
                                            }
                                        }else{
                                            for name in getKor{
                                                if name.language?.name == "en"{
                                                    self.firstCharDesc = name.flavorText ?? ""
                                                }
                                            }
                                        }
                                    }
                                    
                                }

                            }else{
                                let getKoreanAbility = try await PokemonAPI().pokemonService.fetchAbility(urlToInt(url: ab.ability?.url ?? ""))
                               
                                if  let names = getKoreanAbility.names{
                                    if names.contains(where: {$0.language?.name == "ko"}){
                                        for name in names{
                                            if name.language?.name == "ko"{
                                                self.secondChar = name.name ?? ""
                                            }
                                        }
                                    }else{
                                        for name in names{
                                            if name.language?.name == "en"{
                                                self.secondChar = name.name ?? ""
                                            }
                                        }
                                    }
                                }
                                if let getKor = getKoreanAbility.flavorTextEntries{
                                    if getKor.isEmpty{
                                        self.secondCharDesc = "...연구결과 손실..."
                                    }else{
                                        if getKor.contains(where: {$0.language?.name == "ko"}){
                                            for name in getKor{
                                                if name.language?.name == "ko"{
                                                    self.secondCharDesc = name.flavorText ?? ""
                                                }
                                            }
                                        }else{
                                            for name in getKor{
                                                if name.language?.name == "en"{
                                                    self.secondCharDesc = name.flavorText ?? ""
                                                }
                                            }
                                        }
                                    }
                                }

                            }
                        }
                        if hiddenChar == firstChar || hiddenChar == secondChar{
                            hiddenChar = ""
                            hiddenCharDesc = ""
                        }
                        
                    }
                }
            }
        }
        
    }
    @MainActor
    func getform(num:Int){
        isForm.removeAll()
        isFormname.removeAll()
        Task{
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(num)
            
            if let forms = pokemon.forms{
                for form in forms {
                    let vari = try await PokemonAPI().pokemonService.fetchPokemonForm(urlToInt(url: form.url ?? ""))
                    if let formsname = vari.formNames{
                        if vari.formName == "" && vari.formName != "own-tempo" &&  !formsname.contains(where: {$0.language?.name == "ko"}){
                            self.isFormname.append("기본")
                        }
                    }
                    if let sp = vari.sprites{
                        if let pokemonForms = vari.formNames{
                            for formName in pokemonForms{
                                if formName.language?.name == "ko"{
                                    if self.dexNum != 773{
                                        self.isFormname.append(formName.name ?? "")
                                    }
                                }
                            }
                                if pokemonForms.contains(where: {$0.language?.name != "ko"}){
                                    if vari.formName == "bug"{
                                        self.isFormname.append("벌레")
                                    }
                                    else if vari.formName == "normal"{
                                        self.isFormname.append("노말")
                                    }
                                    else if vari.formName == "fairy"{
                                        self.isFormname.append("페어리")
                                    }
                                    else if vari.formName == "dark"{
                                        self.isFormname.append("악")
                                    }
                                    else if vari.formName == "flying"{
                                        self.isFormname.append("비행")
                                    }
                                    else if vari.formName == "dragon"{
                                        self.isFormname.append("드래곤")
                                    }
                                    else if vari.formName == "electric"{
                                        self.isFormname.append("전기")
                                    }
                                    else if vari.formName == "fighting"{
                                        self.isFormname.append("격투")
                                    }
                                    else if vari.formName == "fire"{
                                        self.isFormname.append("불꽃")
                                    }
                                    else if vari.formName == "ghost"{
                                        self.isFormname.append("고스트")
                                    }
                                    else if vari.formName == "grass"{
                                        self.isFormname.append("풀")
                                    }
                                    else if vari.formName == "ground"{
                                        self.isFormname.append("땅")
                                    }
                                    else if vari.formName == "ice"{
                                        self.isFormname.append("얼음")
                                    }
                                    else if vari.formName == "poison"{
                                        self.isFormname.append("독")
                                    }
                                    else if vari.formName == "psychic"{
                                        self.isFormname.append("에스퍼")
                                    }
                                    else if vari.formName == "rock"{
                                        self.isFormname.append("바위")
                                    }
                                    else if vari.formName == "steel"{
                                        self.isFormname.append("강철")
                                    }
                                    else if vari.formName == "water"{
                                        self.isFormname.append("물")
                                    }
                                    else if vari.formName == "unknown"{
                                        self.isFormname.append("???")
                                    }
                                }
                            
                        }
                        
                        if sp.frontDefault != nil{   //나메일 414,10269,10270
                            if let sprites = vari.sprites{
                                self.isForm.append(sprites.frontDefault ?? "")
                                
                            }
                        }
                    }
                    
                    
                }
            }
            
        }
    }
    @MainActor
    func getregional(num:Int){
        isRegion.removeAll()
        isRegionName.removeAll()
        Task{
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            if num == 1007 || num == 1008{
                print("asdasd")
                return
            }
            if let vari = species.varieties{
                
                guard vari.count > 1 else { return }
                for isRegion in vari{
                    let another = try await PokemonAPI().pokemonService.fetchPokemon(urlToInt(url: isRegion.pokemon?.url ?? ""))
                    if another.id != 670{
                        self.isRegion.append(urlToInt(url: isRegion.pokemon?.url ?? ""))
                        if let forms = another.forms{
                            for form in forms{
                                let pokemonForm = try await PokemonAPI().pokemonService.fetchPokemonForm(urlToInt(url: form.url ?? ""))
                                if let formsname = pokemonForm.formNames{
                                    if pokemonForm.formName == "" &&  !formsname.contains(where: {$0.language?.name == "ko"}){
                                        self.isRegionName.append("기본")
                                    }
                                }
                                if let names = pokemonForm.formNames{
                                    for i in names{
                                        if i.language?.name == "ko"{
                                            self.isRegionName.append(i.name ?? "")
                                        }
                                    }
                                    if pokemonForm.formName == "rock-star"{
                                        self.isRegionName.append("하드록")
                                    }else if pokemonForm.formName == "starter"{
                                        self.isRegionName.append("스타터")
                                    }
                                    else if pokemonForm.formName == "belle"{
                                        self.isRegionName.append("마담")
                                    }
                                    else if pokemonForm.formName == "pop-star"{
                                        self.isRegionName.append("아이돌")
                                    }
                                    else if pokemonForm.formName == "phd"{
                                        self.isRegionName.append("닥터")
                                    }
                                    else if pokemonForm.formName == "libre"{
                                        self.isRegionName.append("마스크드")
                                    }
                                    else if pokemonForm.formName == "cosplay"{
                                        self.isRegionName.append("코스튬플레이")
                                    }
                                    else if pokemonForm.formName == "gmax"{
                                        self.isRegionName.append("거다이맥스")
                                    }else if pokemonForm.formName == "hisui"{
                                        self.isRegionName.append("히스이")
                                    }
                                    else if pokemonForm.formName == "totem"{
                                        self.isRegionName.append("토템")
                                    }
                                    else if pokemonForm.formName == "paldea"{
                                        self.isRegionName.append("팔데아")
                                    }
                                    else if pokemonForm.formName == "origin"{
                                        if pokemonForm.id == 10414 || pokemonForm.id == 10415{
                                            self.isRegionName.append("오리진폼")
                                        }
                                    }
                                    else if pokemonForm.formName == "white-striped"{
                                        self.isRegionName.append("백색근의 모습")
                                    }
                                    else if pokemonForm.formName == "female"{
                                        if pokemonForm.id == 10417 || pokemonForm.id == 10423{
                                            self.isRegionName.append("암컷의 모습")
                                        }
                                    }
                                    else if pokemonForm.formName == "male"{
                                        if pokemonForm.id == 902 || pokemonForm.id == 916{
                                            self.isRegionName.append("수컷의 모습")
                                        }
                                    }
                                    else if pokemonForm.formName == "incarnate"{
                                        if pokemonForm.id == 905{
                                            self.isRegionName.append("화신폼")
                                        }
                                    }
                                    else if pokemonForm.formName == "therian"{
                                        if pokemonForm.id == 10418{
                                            self.isRegionName.append("영물폼")
                                        }
                                    }
                                    else if pokemonForm.formName == "paldea-combat-breed"{
                                        self.isRegionName.append("팔데아 컴뱃")
                                    }
                                    else if pokemonForm.formName == "paldea-blaze-breed"{
                                        self.isRegionName.append("팔데아 블레이즈")
                                    }
                                    else if pokemonForm.formName == "paldea-aqua-breed"{
                                        self.isRegionName.append("팔데아 워터")
                                    }
                                    else if pokemonForm.formName == "two-segment"{
                                        self.isRegionName.append("두마디폼")
                                    }
                                    else if pokemonForm.formName == "three-segment"{
                                        self.isRegionName.append("세마디폼")
                                    }
                                    else if pokemonForm.formName == "zero"{
                                        if pokemonForm.id == 964{
                                            self.isRegionName.append("나이브폼")
                                        }
                                    }
                                    else if pokemonForm.formName == "hero"{
                                        self.isRegionName.append("마이티폼")
                                    }
                                    else if pokemonForm.formName == "family-of-four"{
                                        self.isRegionName.append("네식구")
                                    }
                                    else if pokemonForm.formName == "family-of-three"{
                                        self.isRegionName.append("세식구")
                                    }
                                    
                                    else if pokemonForm.formName == "curly"{
                                        self.isRegionName.append("젖힌모습")
                                    }
                                    else if pokemonForm.formName == "droopy"{
                                        self.isRegionName.append("늘어진모습")
                                    }
                                    else if pokemonForm.formName == "stretchy"{
                                        self.isRegionName.append("뻗은모습")
                                    }
                                    else if pokemonForm.formName == "blue-plumage"{
                                        self.isRegionName.append("파랑깃털")
                                    }
                                    else if pokemonForm.formName == "yellow-plumage"{
                                        self.isRegionName.append("노랑깃털")
                                    }
                                    else if pokemonForm.formName == "white-plumage"{
                                        self.isRegionName.append("하얀깃털")
                                    }
                                    else if pokemonForm.formName == "green-plumage"{
                                        self.isRegionName.append("초록깃털")
                                    }
                                    else if pokemonForm.formName == "chest"{
                                        self.isRegionName.append("상자폼")
                                    }
                                    else if pokemonForm.formName == "roaming"{
                                        self.isRegionName.append("도보폼")
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
