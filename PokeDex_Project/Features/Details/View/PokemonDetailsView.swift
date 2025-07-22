//
//  PokemonView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import SwiftUI

/// 포켓몬 상세화면
struct PokemonDetailsView: View {
    
    var body: some View {
        Text("Hello, World!")
    }
}

// MARK: - 포켓몬 상세화면 컴포넌트 정의
extension PokemonDetailsView {
    
}

#Preview {
    PokemonDetailsView()
}

//
//import SwiftUI
//import Kingfisher
//import RealmSwift
//import GoogleMobileAds
//
//struct PokemonView: View {
//    @State var pokemonId:Int
//    let monsterball = "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"
//    
//    let statName = ["HP","공격","방어","특공","특방","스피드"]
//    @State var bookmark = false
//    @Binding var hasAppeared: Bool
//    @Environment(\.dismiss) var dismiss
//    @StateObject var vm = PokemonViewModel(pokemonList: [], pokemon: nil)
//    
//    
//    
//    var body: some View {
//        VStack{
//            if let pokemon = vm.pokemon,let variety = vm.variety{
//                headerView(pokemon:pokemon,variety: variety)
//                AdBannerView(adUnitID: Bundle.main.infoDictionary?["SDK_ID"] as! String)
//                    .frame(height: 50)
//                ScrollView(showsIndicators: false){
//                    pokemonView(pokemon: pokemon,variety: variety)
//                    formView(pokemon: pokemon)
//                    info1View(pokemon: pokemon,variety: variety)
//                    info2View(pokemon: pokemon)
//                    statsView(pokemon: pokemon,variety: variety)
//                    abilityView(pokemon: pokemon,variety: variety)
//                    evolutionTreeView()
//                    textEntrieView(pokemon: pokemon)
//                    
//                }
//            }
//        }
//        .padding()
//        .onAppear{
//            GADMobileAds.sharedInstance().start(completionHandler: nil)
//            vm.formList = []
//            vm.varieties = []
//            vm.fetchPokemon(id: pokemonId)
//            if RealmManager.fetchPokemon(num: pokemonId).num == pokemonId{
//                bookmark = true
//            }
//        }
//        .onDisappear{
//            hasAppeared = true
//        }
//    }
//}
//
//#Preview {
//    PokemonView(pokemonId: 1, hasAppeared: .constant(false))
//}
//
//extension PokemonView{
//    func headerView(pokemon:Pokemons,variety:Varieties)->some View{
//        ZStack{
//            HStack(spacing: 0){
//                Button {
//                    dismiss()
//                } label: {
//                    Image(systemName: "chevron.left")
//                        .bold()
//                }.foregroundColor(.primary)
//                HStack{
//                    KFImage(URL(string: monsterball))
//                    Text(String(format : "%04d",pokemon.id))
//                }
//                Spacer()
//                NavigationLink {
//                    CalculateView(pokemon: RealmPokemon(id: "", num: pokemonId, name: pokemon.name + "\(variety.form.name[0].isEmpty ?  "" :  "(\(variety.form.name.first ?? ""))")", image: variety.form.images.first ?? "", types: variety.types, stats: variety.stats)).navigationBarBackButtonHidden()
//                } label: {
//                    Image(systemName: "plus.forwardslash.minus")
//                        .foregroundColor(.white)
//                        .font(.body)
//                        .padding(5)
//                        .background(Circle().foregroundColor(.pink))
//                }.padding(.trailing)
//                
//                Button {
//                    bookmark.toggle()
//                    if !bookmark{
//                        RealmManager.deletePokemon(num: pokemonId)
//                    }else{
//                        let typeList = RealmSwift.List<String>()
//                        typeList.append(objectsIn: variety.types)
//                        
//                        let object = RealmObject()
//                        object.num = pokemonId
//                        object.name = pokemon.name + "\(variety.form.name[0].isEmpty ?  "" :  "(\(variety.form.name.first ?? ""))")"
//                        object.image = variety.form.images.first ?? ""
//                        object.types = typeList
//                        RealmManager.storePokemon(pokemon: object)
//                    }
//                } label: {
//                    Image(systemName: bookmark ? "bookmark.fill" : "bookmark")
//                        .foregroundColor(.primary)
//                        .font(.title3)
//                }
//            }
//            Text(pokemon.name)
//                .font(.title3)
//                .bold()
//        }
//        .background(Color.typeColor("antiPrimary"))
//    }
//    func pokemonView(pokemon:Pokemons,variety:Varieties)->some View{
//        VStack{
//            HStack{
//                Button {
//                    if pokemonId == 1 { pokemonId = 1025}
//                    else{ pokemonId -= 1 }
//                    vm.variety = nil
//                    vm.formList = []
//                    vm.varieties = []
//                    vm.fetchPokemon(id: pokemonId)
//                    bookmark = false
//                    if RealmManager.fetchPokemon(num: pokemonId).num == pokemonId{
//                        bookmark = true
//                    }
//                } label: {
//                    Image(systemName: "chevron.left")
//                        .font(.title)
//                        .foregroundColor(.primary)
//                }
//                
//                ZStack{
//                    BallImageView()
//                        .frame(width: UIScreen.main.bounds.width/1.5,height: UIScreen.main.bounds.width/1.5)
//                    KFImage(URL(string: variety.form.images.first ?? ""))
//                        .resizable()
//                        .frame(width: UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.width/2)
//                }
//                Button {
//                    if pokemonId == 1025 { pokemonId = 1}
//                    else{ pokemonId += 1 }
//                    vm.variety = nil
//                    vm.formList = []
//                    vm.varieties = []
//                    vm.fetchPokemon(id: pokemonId)
//                    bookmark = false
//                    if RealmManager.fetchPokemon(num: pokemonId).num == pokemonId{
//                        bookmark = true
//                    }
//                } label: {
//                    Image(systemName: "chevron.right")
//                        .font(.title)
//                        .foregroundColor(.primary)
//                }
//            }
//            .padding(.bottom)
//            HStack{
//                ForEach(variety.types,id: \.self){ type in
//                    TypesView(type: type, width: 100, height: 25, font: .body)
//                }
//            }
//        }
//        
//    }
//    func formView(pokemon:Pokemons)->some View{
//        VStack{
//            if vm.varieties.count != 1{
//                VStack(alignment: .leading){
//                    Text("다른 폼").bold().padding(.top)
//                    ScrollView(.horizontal,showsIndicators: false) {
//                        HStack{
//                            ForEach(vm.varieties,id:\.self){ variety in
//                                Button {
//                                    vm.variety = variety
//                                } label: {
//                                    VStack{
//                                        KFImage(URL(string: variety.form.images.first ?? ""))
//                                            .resizable()
//                                            .frame(width: 50,height: 50)
//                                        Text((variety.form.name.first?.isEmpty ?? false) ? "기본" : variety.form.name.first ?? "")
//                                            .font(.caption2)
//                                    }
//                                    .foregroundColor(.primary)
//                                    .opacity(vm.variety == variety ? 1 : 0.4)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            if var variety = vm.variety{
//                if let count = vm.variety?.form.images.count,count > 1{
//                    VStack(alignment: .leading){
//                        Text("다른 모습").bold().padding(.top)
//                        ScrollView(.horizontal,showsIndicators: false) {
//                            HStack{
//                                ForEach(0..<count,id:\.self){ index in
//                                    Button {
//                                        switch pokemonId{
//                                        case 493: variety.types = [variety.form.name[index]]
//                                        case 773:
//                                            if let type = SilverDFilter(rawValue: variety.form.name[index]){
//                                                variety.types = [type.type]
//                                            }
//                                        default:break
//                                        }
//                                        variety.form.images[0] = vm.formList[index]
//                                        vm.variety = variety
//                                    } label: {
//                                        VStack{
//                                            KFImage(URL(string: vm.formList[index]))
//                                                .resizable()
//                                                .frame(width: 50,height: 50)
//                                            Text(variety.form.name[index])
//                                                .font(.caption2)
//                                        }
//                                        .foregroundColor(.primary)
//                                        .opacity(variety.form.images[0] == vm.formList[index] ? 1 : 0.4)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    func info1View(pokemon:Pokemons,variety:Varieties)->some View{
//        VStack{
//            HStack(alignment: .top){
//                Group{
//                    Text("분류").bold().padding(.bottom,5)
//                    Text("키").bold().padding(.bottom,5)
//                    Text("무게").bold().padding(.bottom,5)
//                    Text("포획률").bold().padding(.bottom,5)
//                }
//                .frame(maxWidth: .infinity)
//                
//            }
//            .padding(.top)
//            HStack{
//                Group{
//                    Text("\(pokemon.genra)").font(.callout)
//                    Text("\(variety.height, specifier: "%.1f")m").font(.callout)
//                    Text("\(variety.weight,specifier: "%.1f")kg").font(.callout)
//                    Text("\(pokemon.captureRate)").font(.callout)
//                }
//                .frame(maxWidth: .infinity)
//            }
//        }
//    }
//    func info2View(pokemon:Pokemons)->some View{
//        VStack{
//            HStack{
//                Group{
//                    Text("알그룹").bold().padding(.bottom,5)
//                    Text("성비").bold().padding(.bottom,5)
//                    Text("부화수").bold().padding(.bottom,5)
//                }
//                .frame(maxWidth: .infinity)
//            }
//            .padding(.top)
//            HStack{
//                Group{
//                    VStack{
//                        ForEach(pokemon.eggGroup,id: \.self){ egg in
//                            Text(egg)
//                        }
//                    }
//                    VStack{
//                        if pokemon.genderRate == -1{
//                            Text("성별없음")
//                        }else{
//                            Text("수컷 : \(100 - (Double(pokemon.genderRate)/8 * 100), specifier: "%.1f")%").font(.callout)
//                            Text("암컷 : \(Double(pokemon.genderRate)/8 * 100, specifier: "%.1f")%").font(.callout)
//                        }
//                    }
//                    
//                    Text("\(pokemon.hatchCounter)").font(.callout)
//                }
//                .frame(maxWidth: .infinity)
//            }
//        }
//    }
//    func statsView(pokemon:Pokemons,variety:Varieties)->some View{
//        VStack{
//            Text("종족값").bold().padding(.top)
//            HStack{
//                Group{
//                    ForEach(0..<variety.stats.count,id:\.self){ index in
//                        VStack{
//                            Text(statName[index]).bold()
//                            Text("\(variety.stats[index])")
//                        }
//                    }
//                    VStack{
//                        Text("합계").bold()
//                        Text("\(variety.stats.reduce(0, +))")
//                    }
//                }
//                .frame(width: UIScreen.main.bounds.width/9,height: 70)
//                .background(Color.gray.opacity(0.2))
//            }.font(.callout)
//        }
//    }
//    func abilityView(pokemon:Pokemons,variety:Varieties)->some View{
//        VStack{
//            Text("특성").bold().padding(.top)
//            ForEach(0..<variety.abilites.isHidden.count,id: \.self){ index in
//                HStack{
//                    HStack(spacing:1){
//                        Text(variety.abilites.name[index])
//                        if variety.abilites.isHidden[index]{
//                            Image(systemName: "star.fill")
//                                .font(.caption2)
//                        }
//                    }
//                    .frame(width: 100)
//                    .frame(height: 60)
//                    .background(Color.gray.opacity(0.2))
//                    Spacer()
//                    Text(variety.abilites.text[index].replacingOccurrences(of: "\n", with: " "))
//                    Spacer()
//                }
//                .background(Color.typeColor(pokemon.color).opacity(0.2))
//                .cornerRadius(10)
//                
//            }
//            .font(.system(size: 13))
//        }
//    }
//    func evolutionTreeView()-> some View{
//        VStack{
//            Text("진화트리")
//                .bold()
//                .padding(.top)
//            EvolTreeNodeView(node:  vm.evolutionTree ?? EvolutionTo(image: [], name: ""))
//                .environmentObject(vm)
//        }
//    }
//    func textEntrieView(pokemon:Pokemons)->some View{
//        VStack{
//            Text("도감 설명")
//                .bold()
//                .padding(.top)
//            ForEach(0..<pokemon.textEntries.text.count,id: \.self){ index in
//                HStack{
//                    Text(pokemon.textEntries.version[index])
//                        .frame(width: 100)
//                        .frame(height: 60)
//                        .background(Color.gray.opacity(0.2))
//                    Spacer()
//                    Text(pokemon.textEntries.text[index].replacingOccurrences(of: "\n", with: " "))
//                    Spacer()
//                }
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(10)
//                
//            }
//            .font(.system(size: 13))
//        }
//    }
//}
