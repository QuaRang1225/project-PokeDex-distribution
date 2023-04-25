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
                    ForEach(vm.image,id:\.self){ item in
                        KFImage(URL(string: item))
                            .resizable()
                            .frame(width: 100,height: 100)
                    }
                    
                    Text(vm.name)
                    HStack{
                        Text(vm.type)
                        if vm.type2.last != vm.type  {
                            Text(" / ")
                            ForEach(vm.type2,id:\.self){ item in
                                Text(item)
                            }
                        }
                       
                        
                    }
                    Group{
                        Text(vm.genera)
                        Text(String(format: "%.1f", Double(vm.weight)*0.1) + "kg")
                        Text(String(format: "%.1f", Double(vm.height)*0.1) + "m")
                        HStack{
                            Text("알그룹")
                            ForEach(vm.egg,id:\.self){ item in
                                Text(item)
                            }
                        }
                    }
                    Group{
                        ForEach(Array(vm.baby),id:\.0){ key, value in
                            HStack{
                                Text(key)
                                KFImage(URL(string: value))
                                    .resizable()
                                    .frame(width: 100,height: 100)
                                    
                            }
                        }
                        ForEach(Array(vm.junior),id:\.0){ key, value in
                            HStack{
                                Text(key)
                                KFImage(URL(string: value))
                                    .resizable()
                                    .frame(width: 100,height: 100)
                                    
                            }
                        }
                        ForEach(Array(vm.senior),id:\.0){ key, value in
                            HStack{
                                Text(key)
                                KFImage(URL(string: value))
                                    .resizable()
                                    .frame(width: 100,height: 100)
                                    
                            }
                        }
                    }
                    
//                    ForEach(Array(vm.chrac),id:\.0){ key, value in
//                        HStack{
//                            Text("\(value ? "숨겨진 특성" : "일반 특성")")
//                            Text(key)
//                        }
//
//                    }
                    ForEach(vm.chrac,id:\.self){ item in
                        Text("특성: " + item)
                    }
                    ForEach(vm.hiddenChrac,id:\.self){ item in
                        Text("숨겨진 특성: " + item)
                    }
                    ForEach(Array(vm.stat),id:\.0){ key, value in
                        HStack{
                            Text(key)
                            Text("\(value)")
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



