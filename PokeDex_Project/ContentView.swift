//
//  ContentView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/21.
//

import SwiftUI
import PokemonAPI
import Kingfisher

struct ContentView: View {
    @StateObject var vm = PokemonViewModel()
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    Text("도감번호 : " + String(format: "%04d", vm.num))
                    ForEach(Array(zip(vm.image,vm.formName)),id:\.0){ (image,form) in
                        VStack{
                            Text(form)
                            KFImage(URL(string: image))
                                .resizable()
                                .frame(width: 100,height: 100)
                        }
                    }
                    
                    Text(vm.name)
                    HStack{
                        ForEach(vm.type,id: \.self){ type in
                            Text(type)
                        }
                        if !vm.type2.isEmpty{
                            Text("다른폼")
                            ForEach(vm.type2,id: \.self){ type in
                                Text(type)
                            }
                        }
                        
                        
                    }
                    Group{
                        Text(vm.genera)
                        Text(String(format: "%.1f", Double(vm.weight)*0.1) + "kg")
                        Text(String(format: "%.1f", Double(vm.height)*0.1) + "m")
                        HStack{
                            VStack{
                                Text(" ")
                                ForEach(vm.formName,id:\.self){ item in
                                    Text("\(item)")
                                }
                            }
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
                        HStack{
                            Text("알그룹")
                            ForEach(vm.egg,id:\.self){ item in
                                Text(item)
                            }
                        }
                    }
                    Group{
                        ForEach(vm.baby.keys.sorted(), id: \.self) { key in
                                VStack(alignment: .leading) {
                                    Text(key)
                                        .font(.headline)
                                    ForEach(vm.baby[key]!, id: \.self) { value in
                                        KFImage(URL(string: value))
                                            .resizable()
                                            .frame(width: 100,height: 100)
                                    }
                                }
                        }
                        ForEach(vm.junior.keys.sorted(), id: \.self) { key in
                                VStack(alignment: .leading) {
                                    Text(key)
                                        .font(.headline)
                                    ForEach(vm.junior[key]!, id: \.self) { value in
                                        KFImage(URL(string: value))
                                            .resizable()
                                            .frame(width: 100,height: 100)
                                    }
                                }
                        }
                        ForEach(vm.senior.keys.sorted(), id: \.self) { key in
                                VStack(alignment: .leading) {
                                    Text(key)
                                        .font(.headline)
                                    ForEach(vm.senior[key]!, id: \.self) { value in
                                        KFImage(URL(string: value))
                                            .resizable()
                                            .frame(width: 100,height: 100)
                                    }
                                }
                        }
                    }
                    HStack{
                        Text("특성: ")
                        ForEach(vm.chrac,id:\.self){ item in
                            Text(item)
                        }
                    }
                    
                    if !vm.hiddenChrac.isEmpty{
                        Text("숨겨진 특성: " + vm.hiddenChrac)
                        ForEach(Array(vm.stat),id:\.0){ key, value in
                            HStack{
                                Text(key)
                                Text("\(value)")
                            }
                        }
                    }
                    

                    ForEach(vm.desc.filter({$0.range(of: "[가-힣]+", options: .regularExpression) != nil}),id:\.self){ item in
                        Text(item)
                    }
                }.padding(.bottom,5)
            }
        }
        .onAppear{
            vm.call()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



