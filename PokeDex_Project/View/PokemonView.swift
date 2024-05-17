//
//  PokemonView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import SwiftUI
import Kingfisher

struct PokemonView: View {
    let pokemonId:Int
    let monsterball = "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = PokemonViewModel(pokemonList: [], pokemon: nil)
    var body: some View {
        VStack{
            if let pokemon = vm.pokemon{
                ZStack{
                    HStack(spacing: 0){
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .bold()
                            KFImage(URL(string: monsterball))
                            Text(String(format : "%04d",pokemon.id))
                        }.foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "bookmark")
                            .font(.title3)
                    }
                    Text(pokemon.name)
                        .font(.title3)
                        .bold()
                }
                .background(Color.typeColor("antiPrimary"))
                ScrollView(showsIndicators: false){
                    ZStack{
                        BallImageView()
                            .frame(width: UIScreen.main.bounds.width/1.5,height: UIScreen.main.bounds.width/1.5)
                        KFImage(URL(string: pokemon.base.image))
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.width/2)
                    }
                    .padding(.bottom)
                    HStack{
                        ForEach(pokemon.base.types,id: \.self){ type in
                            TypesView(type: type, width: 100, height: 25, font: .body)
                        }
                    }
                    HStack(alignment: .top){
                        Group{
                            Text("분류").bold().padding(.bottom,5)
                            Text("키").bold().padding(.bottom,5)
                            Text("무게").bold().padding(.bottom,5)
                            Text("포획률").bold().padding(.bottom,5)
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                    .padding(.top)
                    HStack{
                        Group{
                            Text("\(pokemon.genra)").font(.callout)
                            Text("\(0.1, specifier: "%.1f")m").font(.callout)
                            Text("\(2)kg").font(.callout)
                            Text("\(pokemon.captureRate)").font(.callout)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    HStack{
                        Group{
                            Text("알그룹").bold().padding(.bottom,5)
                            Text("성비").bold().padding(.bottom,5)
                            Text("부화수").bold().padding(.bottom,5)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top)
                    HStack{
                        Group{
                            VStack{
                                ForEach(pokemon.eggGroup,id: \.self){ egg in
                                    Text(egg)
                                }
                            }
                            VStack{
                                if pokemon.genderRate == 0{
                                    Text("성별없음")
                                }else{
                                    Text("수컷 : \(100 - (Double(pokemon.genderRate)/8 * 100), specifier: "%.1f")%").font(.callout)
                                    Text("암컷 : \(Double(pokemon.genderRate)/8 * 100, specifier: "%.1f")%").font(.callout)
                                }
                            }
                            
                            Text("\(pokemon.hatchCounter)").font(.callout)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    Text("도감 설명")
                        .bold()
                        .padding(.top)
                    ForEach(0..<pokemon.textEntries.text.count,id: \.self){ index in
                        HStack{
                            Text(pokemon.textEntries.version[index])
                                .frame(width: 100)
                                .frame(height: 60)
                                .background(Color.gray.opacity(0.2))
                            Spacer()
                            Text(pokemon.textEntries.text[index].replacingOccurrences(of: "\n", with: " "))
                            Spacer()
                        }
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        
                    }
                    .font(.system(size: 13))
                    
                }
            }
        }
        .padding()
        .onAppear{
            vm.fetchPokemon(id: pokemonId)
            
        }
    }
}

#Preview {
    PokemonView(pokemonId: 1)
}
