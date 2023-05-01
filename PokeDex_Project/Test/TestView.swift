//
//  TestView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/26.
//
import SwiftUI

struct TestView: View {
    @State private var searchText = ""
    @State private var searchResults = [String]()

    var body: some View {
        VStack {
            TextField("Search", text: $searchText, onEditingChanged: { _ in
                // 포커스가 맞춰졌을 때 호출
                search()
            })
            .textFieldStyle(.roundedBorder)
            .padding()

            List(searchResults, id: \.self) { result in
                Text(result)
            }
        }
    }

    private func search() {
        searchResults = ["Apple", "Banana", "Cherry", "Durian", "Elderberry", "Fig"]
            .filter { searchText.isEmpty ? true : $0.lowercased().contains(searchText.lowercased()) }
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
