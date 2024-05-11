//
//  MainView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = PokemonViewModel()
    var body: some View {
        Text(vm.pokemon?.name ?? "")
            .onAppear{
                vm.fetchPokemon(id: 1)
            }
    }
}

#Preview {
    MainView()
}
