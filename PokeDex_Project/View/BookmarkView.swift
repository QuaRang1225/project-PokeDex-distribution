//
//  BookmarkView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import SwiftUI

struct BookmarkView: View {
    @State var pokemonList:[RealmPokemon] = []
    var body: some View {
        VStack{
            Button {
                RealmManager.deleteAll()
                pokemonList = RealmManager.fetchPokemons()
            } label: {
                Image(systemName: "trash")
            }
            List{
                ForEach(pokemonList,id: \.self){ a in
                    Text(a.name)
                        
                }
            }
            
        }
        .onAppear{
            pokemonList = RealmManager.fetchPokemons()
        }
    }
}

#Preview {
    BookmarkView()
}
