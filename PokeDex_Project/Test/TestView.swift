//
//  TestView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/26.
//

import SwiftUI

struct TestView: View {
    @StateObject var vm = ViewModel()
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text("\(vm.model.a)")
            Text("\(vm.model.b)")
        }
        .onAppear{
            vm.get()
            vm.get1()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

struct Model:Codable{
    var a:Int
    var b:Int
}
class ViewModel:ObservableObject{
    @Published var model = Model(a: 0, b: 0)
    func get(){
        model.a = 1
    }
    func get1(){
        model.b = 2
    }
}
