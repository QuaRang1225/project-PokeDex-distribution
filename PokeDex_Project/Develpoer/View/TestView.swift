//
//  TestView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/08/19.
//

import SwiftUI
import PokemonAPI

struct TestView: View {
    let pokemon = 133
    @StateObject var vm = MoveSaveViewModel()
    var body: some View {
        VStack{
            Button {
                Task{
                    vm.getItemList()
                }
            } label: {
                Text("아이템DB저장")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(20)
            }
            Button {
                Task{
                     await vm.getMove()
                }
            } label: {
                Text("기술DB저장")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(20)
            }
            Button {
                Task{
                    vm.getPokemon(num:pokemon)
                    vm.getSpecies(num:pokemon)
                }
            } label: {
                Text("테스트")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(20)
            }

        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
