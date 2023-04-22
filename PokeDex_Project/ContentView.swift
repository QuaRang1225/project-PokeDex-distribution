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
                    ForEach(Array(vm.desc.enumerated()),id:\.offset){ index,item in
                        HStack{
                            Text("\(index)")
                            Text(item)
                        }
                        
                    }
                    
                    ForEach(Array(vm.chrac),id:\.0){ key, value in
                        HStack{
                            Text("\(value ? "숨겨진 특성" : "일반 특성")")
                            Text(key)
                        }
                        
                    }
                    ForEach(Array(vm.stat),id:\.0){ key, value in
                        HStack{
                            Text(key)
                            Text("\(value)")
                        }
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


