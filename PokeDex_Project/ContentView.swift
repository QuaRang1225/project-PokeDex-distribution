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
                    KFImage(URL(string: vm.image))
                        .resizable()
                        .frame(width: 100,height: 100)
                    Text(vm.name)
                    HStack{
                        Text(vm.type)
                        Text(vm.type2)
                    }
                    Text(String(format: "%.1f", Double(vm.weight)*0.1) + "kg")
                    Text(String(format: "%.1f", Double(vm.height)*0.1) + "m")
                    
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
//                    ForEach(Array(zip(LocationFilter.allCases, vm.desc)),id:\.0){ (loc,des) in
//
//                        HStack{
//                            Text(loc.name)
//                            Text(des)
//                        }
//                    }
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



