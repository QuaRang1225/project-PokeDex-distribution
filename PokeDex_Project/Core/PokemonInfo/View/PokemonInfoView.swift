//
//  PokemonInfoView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/27.
//

import SwiftUI
import Kingfisher

struct PokemonInfoView: View {
    @StateObject var vm = PokemonViewModel()
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            //header
            VStack{
                header
                
                ScrollView{
                    Group{
                        HStack(spacing: 0){
                            Text("도감번호 ")
                                .bold()
                            KFImage(URL(string: "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"))
                            
                            Text("0001")
                        }
                        .padding(.top,30)
                        .padding(.bottom,20)
                        ZStack{
                            BallImage()
                                .frame(width: 200,height: 200)
                            ForEach(vm.image,id:\.self){
                                KFImage(URL(string: $0))
                                    .resizable()
                                    .frame(width: 200,height: 200)
                            }
                            
                        }
                    }
                    
                    
                    
                    HStack{
                        Group{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.typeColor(types: "grass"))
                                .frame(width: 70,height: 25)
                                .overlay {
                                    Text("풀")
                                        .shadow(radius: 10)
                                }
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.typeColor(types: "poison"))
                                .frame(width: 70,height: 25)
                                .overlay {
                                    Text("독")
                                        .shadow(radius: 10)
                                }
                        }
                        .bold()
                        .foregroundColor(.white)
                    }
                    .padding(.top,30)
                    
                    HStack{
                        Text("씨앗포켓몬")
                        Spacer()
                        Text("키 : 0.7m")
                        Spacer()
                        Text("몸무게 : 6.9kg")
                        
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
                    HStack{
                        Group{
                            VStack{
                                Text("HP")
                                ForEach(vm.hp,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("공격")
                                ForEach(vm.attack,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("방어")
                                ForEach(vm.defense,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("특공")
                                ForEach(vm.spAttack,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("특방")
                                ForEach(vm.spDefense,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("스피드")
                                ForEach(vm.speed,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
                            VStack{
                                Text("합계")
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
                        Text("도감설명")
                            .frame(maxWidth:.infinity)
                        VStack(alignment: .leading) {
                            ForEach(Array(Set(vm.desc)).filter({$0.range(of: "[가-힣]+", options: .regularExpression) != nil}),id:\.self){ item in
                                Text(item.replacingOccurrences(of: "\n", with: " "))
                                    .padding(.bottom,5)
                                Divider()
                            }
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray.opacity(0.5)))
                            .padding(.horizontal)
                    }
                    Group{
                        Text("진화")
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
                }
            }
        }
        .foregroundColor(.black)
        .onAppear{
            vm.call()
        }
        
    }
    var header:some View{
        ZStack{
            HStack{
                Image(systemName: "chevron.left")
                Spacer()
                Image(systemName: "star")
            }
            Text("이상해씨")
                .bold()
                .font(.title3)
        }
        .padding(.horizontal,20)
    }
}

struct PokemonInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoView()
    }
}
