//
//  PokemonInfoView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/27.
//

import SwiftUI
import Kingfisher
import PokemonAPI

struct PokemonInfoView: View {
    @StateObject var vm = PokemonInfoViewModel()
    @Binding var back:Bool
    let coloumn = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    let num:Int
    var body: some View {
            VStack{
                header
                ScrollView{
                    Group{
                        HStack(spacing: 0){
                            KFImage(URL(string: "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"))
                            Text(String(format: "%04d",num))
                                .bold()
                        }
                        .padding(.top,30)
                        .padding(.bottom,20)
                        ZStack{
                            BallImage()
                                .frame(width: 200,height: 200)
                            KFImage(URL(string: vm.image))
                                .resizable()
                                .frame(width: 200,height: 200)
                            
                        }
                    }
                    
                    
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 75,height: 25)
                            .foregroundColor(Color.typeColor(types: vm.types.first ?? ""))
                            .overlay {
                                Text(vm.types.first ?? "")
                                    .shadow(color: .black, radius: 2)
                                    .padding(.horizontal)
                                    .padding(2)
                            }

                        if vm.types.count > 1 {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 75,height: 25)
                                .foregroundColor(Color.typeColor(types: vm.types.last ?? ""))
                                .overlay {
                                    Text(vm.types.last ?? "")
                                        .shadow(color: .black, radius: 2)
                                        .padding(.horizontal)
                                        .padding(2)
                                }
                        }
                    }
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                    
                    HStack{
                        Text(vm.genera)
                        Spacer()
                        Text("키 : " + String(format: "%.1f", Double(vm.height)*0.1) + "m")
                        Spacer()
                        Text("몸무게 : " + String(format: "%.1f", Double(vm.weight)*0.1) + "kg")
                        
                    }
                    .padding(.vertical,5)
                    .padding(.horizontal,30)
                    VStack{
                        HStack{
                            Group{
                                Text("알그룹")
                                Text("성비")
                                Text("포획률")
                            }.frame(maxWidth: .infinity)
                            
                        }
                        .bold()
                        .padding(.bottom,5)
                        HStack{
                            Group{
                                HStack(spacing:0){
                                    ForEach(vm.eggGroup,id:\.self){
                                        Text($0)
                                        if vm.eggGroup.count > 1,$0 != vm.eggGroup.last{
                                            Text("  ")
                                        }
                                        
                                    }
                                }
                                VStack{
                                    if vm.gender.contains(1){
                                        Text("성별 없음")
                                    }else{
                                        Text("수컷 : \(String(format: "%.1f", vm.gender.first ?? 0)) %")
                                        Text("암컷 : \(String(format: "%.1f", vm.gender.last ?? 0))%")
                                    }
                                    
                                }
                                Text("\(vm.get)")
                            }.frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical,15)
                    .background(Color.gray.opacity(0.2).cornerRadius(20))
                    .padding()
                    Text("특성")
                        .font(.title3)
                        .bold()
                    VStack{
                        
                        Group{
                            VStack(alignment:.leading, spacing:0){
                                ForEach(Array(vm.char),id:\.0){ (key,value) in
                                    HStack(spacing: 0){
                                        Text(key)
                                            .padding(.trailing)
                                            .bold()
                                        Text(value.replacingOccurrences(of: "\n", with: " "))
                                    }
                                }.padding(.bottom)
                                if !vm.hiddenChar.keys.contains("no"){
                                    ForEach(Array(vm.hiddenChar),id:\.0){ (key,value) in
                                        HStack(spacing: 0){
                                            Text(key).bold()
                                            Image(systemName:"questionmark.circle.fill")
                                                .padding(.trailing)
                                            Text(value.replacingOccurrences(of: "\n", with: " "))
                                        }
                                    }
                                }
                                
                            }
                        
                        }.frame(maxWidth: .infinity,alignment:.leading)
                    }
                    
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray.opacity(0.5)))
                    .padding(.horizontal)
                    .padding(.bottom,20)
                    Text("종족값")
                        .font(.title3)
                        .bold()
                    HStack{
                        Group{
                            VStack{
                                Text("HP")
                                    .bold()
                                ForEach(vm.hp,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("공격")
                                    .bold()
                                ForEach(vm.attack,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("방어")
                                    .bold()
                                ForEach(vm.defense,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("특공")
                                    .bold()
                                ForEach(vm.spAttack,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("특방")
                                    .bold()
                                ForEach(vm.spDefense,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("스피드")
                                    .bold()
                                ForEach(vm.speed,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("합계")
                                    .bold()
                                ForEach(vm.avr,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 600 ? .red : .primary)
                                        .bold()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                    }
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray.opacity(0.5)))
                    .padding(.horizontal)
                    .padding(.bottom)
                    VStack{
                        Group{
                            Text("진화")
                                .font(.title3)
                                .bold()
                            VStack{
                                ForEach(Array(vm.frist),id:\.0){ (key,value) in
                                    VStack{
                                        KFImage(URL(string: value)!)
                                            .resizable()
                                            .frame(width: 100,height:100)
                                        Text(key)
                                    }
                                    .background(BallImage())
                                }
                                LazyVGrid(columns: coloumn,alignment:.center) {
                                    ForEach(Array(vm.second),id:\.0){ (key,value) in
                                        VStack{
                                            KFImage(URL(string: value)!)
                                                .resizable()
                                                .frame(width: 100,height:100)
                                            Text(key)
                                        }
                                        .background(BallImage())
                                    }
                                }
                                ForEach(Array(vm.third),id:\.0){ (key,value) in
                                    VStack{
                                        KFImage(URL(string: value)!)
                                            .resizable()
                                            .frame(width: 100,height:100)
                                        Text(key)
                                    }
                                    .background(BallImage())
                                }
                            }.padding()
                        }
                    }.padding(.vertical)
                   
                    VStack{
                        Text("도감설명")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth:.infinity)
                        VStack(alignment: .leading) {
                            ForEach(Array(Set(vm.desc)).filter({$0.range(of: "[가-힣]+", options: .regularExpression) != nil}),id:\.self){ item in
                                HStack{
                                    Circle()
                                        .frame(width:5,height:5)
                                        .padding(.trailing,5)
                                    Text(item.replacingOccurrences(of: "\n", with: " "))
                                        .padding(.bottom,5)
                                }
                                
                            }
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray.opacity(0.5)))
                            .padding(.horizontal)
                    }
                    
                }
            }
        .onAppear{
            vm.getInfo(num: num)
        }
        
    }
    var header:some View{
        ZStack{
            HStack{
                Button {
                    back = false
                } label: {
                    Image(systemName: "chevron.left")
                }
                .foregroundColor(.primary)

                
                Spacer()
                Image(systemName: "star")
            }
            Text(vm.name)
                .bold()
                .font(.title3)
        }
        .padding(.horizontal,20)
    }
}

struct PokemonInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoView(back: .constant(true),num: 182)
    }
}

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
    
    @Published var frist = [String:String]()
    @Published var second = [String:String]()
    @Published var third = [String:String]()
    
    @Published var desc = [String]()
    
    private func urlToInt(url:String)->Int{
        let url = Int(String(url.filter({$0.isNumber}).dropFirst()))!
        return url
    }
    private func imageUrl(url:Int)->String{
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"
    }
    func getKoreanName(num: Int) async -> String {  //포켓몬 이름/한글로 변환
        let species = try? await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
        
        if let name = species?.names, name.count < 3{
            if num == 1009{
                return "굽이치는 물결"
            }else{
                return "무쇠잎새"
            }
        }else if num == 505{
            return "보르그"
        }else{
            return species?.names?[2].name ?? "이름없음"
        }
        
        
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
    
    func getInfo(num:Int){
        
        image = imageUrl(url: num)
        Task{
            let name = await getKoreanName(num: num)
            let types = await getKoreanType(num: num)
            
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(num)
            let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
            
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
                                self.frist[kor.name ?? ""] = self.imageUrl(url: self.urlToInt(url: evolChain.chain?.species?.url ?? ""))
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
                                        self.second[kor.name ?? ""] = self.imageUrl(url: self.urlToInt(url: second.species?.url ?? ""))
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
                                                self.third[kor.name ?? ""] = self.imageUrl(url: self.urlToInt(url: third.species?.url ?? ""))
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
