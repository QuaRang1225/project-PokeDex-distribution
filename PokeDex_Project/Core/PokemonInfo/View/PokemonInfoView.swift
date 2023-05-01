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
                        Text("씨앗포켓몬")
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
                                Text("괴수  식물")
                                VStack{
                                    Text("수컷 : 87.5%")
                                    Text("암컷 : 12.5%")
                                }
                                Text("45")
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
                            HStack(spacing: 0){
                                Text("심록")
                                    .padding(.trailing)
                                    .bold()
                                Text("HP가 ⅓ 이하일 때 풀 타입 기술의 위력이 1.5배가 된다.")
                            }
                            .padding(.bottom)
                            HStack(spacing: 0){
                                Text("엽록소")
                                    .bold()
                                Image(systemName: "questionmark.circle.fill")
                                    .padding(.trailing)
                                Text("날씨가 쾌청 상태일 때 스피드가 2배가 된다.")
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
                                }
                            }
                            VStack{
                                Text("공격")
                                    .bold()
                                ForEach(vm.attack,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("방어")
                                    .bold()
                                ForEach(vm.defense,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("특공")
                                    .bold()
                                ForEach(vm.spAttack,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("특방")
                                    .bold()
                                ForEach(vm.spDefense,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("스피드")
                                    .bold()
                                ForEach(vm.speed,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("합계")
                                    .bold()
                                ForEach(vm.avr,id:\.self){ item in
                                    Text("\(item)")
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
                            HStack{
                                ForEach(1...3,id:\.self){ url in
                                    KFImage(URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"))
                                        .resizable()
                                        .frame(width: 100,height:100)
                                    if url < 3{
                                        Image(systemName: "chevron.right")
                                    }
                                    
                                }
                            }
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
        PokemonInfoView(back: .constant(true),num: 2)
    }
}

class PokemonInfoViewModel:ObservableObject{
    
    @Published var image = String()
    @Published var name = String()
    @Published var title = String()
    @Published var height = Int()
    @Published var weight = Int()
    @Published var eggGroup = [String]()
    @Published var gender = [String]()
    @Published var get = Int()
    @Published var char = [String:String]()
    @Published var hiddenChar = [String:String]()
    @Published var types = [String]()
    
    @Published var hp = [Int]()
    @Published var attack = [Int]()
    @Published var defense = [Int]()
    @Published var spAttack = [Int]()
    @Published var spDefense = [Int]()
    @Published var speed = [Int]()
    @Published var avr = [Int]()
    
    @Published var fist = [String:String]()
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
            
            DispatchQueue.main.async {
                self.name = name
                self.types = types
            }
            
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(num)
            DispatchQueue.main.async {
                self.height = pokemon.height!
                self.weight = pokemon.weight!
            }
            
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
        
    }
}
