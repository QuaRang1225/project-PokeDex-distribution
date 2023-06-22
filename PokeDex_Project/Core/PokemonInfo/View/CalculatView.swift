//
//  CalculatView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/06/22.
//

import SwiftUI
import Kingfisher

struct CalculatView: View {
    @Binding var num:Int
    @Binding var formName:String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm:PokemonInfoViewModel
    var body: some View {
        VStack{
            header
            ScrollView(showsIndicators: false) {
                thumbnail
                stats
            }
        }
    }
}

struct CalculatView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatView(num: .constant(1), formName: .constant(""))
            .environmentObject(PokemonInfoViewModel())
    }
}


extension CalculatView{
    var header:some View{
        ZStack{
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()

               
            }
            .foregroundColor(.primary)
            Text("계산기")
                .bold()
                .font(.title3)
        }
        .padding(.horizontal,20)
    }
    var thumbnail:some View{
        
        VStack(alignment: .leading){
            HStack{
                ball
                Text(String(format: "%04d",vm.dexNum))
                    .bold()
            }
            .padding(.leading,20)
            .padding(.top,50)
            HStack{
                KFImage(URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(num).png"))
                    .resizable()
                    .frame(width: 70, height: 70)
                Text(vm.name + "\(formName)")
                Spacer()
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 85,height: 25)
                        .foregroundColor(Color.typeColor(types: vm.types.first ?? ""))
                        .overlay {
                            Text(vm.types.first ?? "")
                                .shadow(color: .black, radius: 2)
                                .padding(.horizontal)
                                .padding(2)
                        }

                    if vm.types.count > 1 {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 85,height: 25)
                            .foregroundColor(Color.typeColor(types: vm.types.last ?? ""))
                            .overlay {
                                Text(vm.types.last ?? "")
                                    .shadow(color: .black, radius: 2)
                                    .padding(.horizontal)
                                    .padding(2)
                            }
                    }
                }
            }.padding(.trailing)
        }
        
    }
    var ball:some View{
        KFImage(URL(string: "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"))
    }
    var stats:some View{
        VStack(spacing: 10) {
            HStack{
                Group{
                    VStack{
                        Text("HP")
                            .bold()
                        ForEach(vm.hp,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("공격")
                            .bold()
                        ForEach(vm.attack,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("방어")
                            .bold()
                        ForEach(vm.defense,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("특공")
                            .bold()
                        ForEach(vm.spAttack,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("특방")
                            .bold()
                        ForEach(vm.spDefense,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("스피드")
                            .bold()
                        ForEach(vm.speed,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("합계")
                            .bold()
                        ForEach(vm.avr,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 600 ? .red : .primary)
                                .bold()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .font(.headline)
                
            }
            .padding(.vertical)
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}
