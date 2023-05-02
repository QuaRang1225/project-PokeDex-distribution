//
//  TestView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/26.
//
import SwiftUI

struct TestView: View {
    @State private var arr  = [Int]()
    @State private var one = Array(0...100)
    @State private var two = Array(101...200)
    @State private var three = Array(201...300)

    var body: some View {
        VStack {
            ScrollView{
                HStack{
                    Button {
                        arr = one
                    } label: {
                        Circle()
                            .frame(width: 100)
                    }
                    Button {
                        arr = two
                    } label: {
                        Circle()
                            .frame(width: 100)
                    }
                    Button {
                        arr = three
                    } label: {
                        Circle()
                            .frame(width: 100)
                    }

                }
                ForEach(arr, id: \.self) { result in
                    Text("\(result)")
                }
            }
            
        }
    }
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

struct Model:Codable{
    var a:String
    var b:Int
}

class ViewModel:ObservableObject{
    @Published var model = Model(a: "", b: 0)

    func get(){
        DispatchQueue.global(qos: .background).async {
            //Firestore
            UserDefaults.standard.setValue("Heo, World!", forKey: "myStringData")
            if let myStringData = UserDefaults.standard.string(forKey: "myStringData") {
                self.model.a = myStringData
            }
            self.model.b = 2
        }
    }
}
