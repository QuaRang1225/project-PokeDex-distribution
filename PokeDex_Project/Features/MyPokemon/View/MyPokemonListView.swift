////
////  BookmarkView.swift
////  PokeDex_Project
////
////  Created by 유영웅 on 5/20/24.
////

import SwiftUI
import Kingfisher
import ComposableArchitecture

/// 북마크 리스트 뷰
struct MyPokemonListView: View {
    typealias BookmarkStore = ViewStoreOf<MyPokemonListFeature>
    let store: StoreOf<MyPokemonListFeature>
    
    var body: some View {
        VStack{
            HStack{
                Text("내 포켓몬")
                    .bold()
                    .font(.title)
                Spacer()
                Button {
                    RealmManager.deleteAll()
                    pokemonList = RealmManager.fetchPokemons()
                } label: {
                    HStack{
                        Text("전체삭제").font(.caption)
                        Image(systemName: "trash")
                    }
                    
                }
                .foregroundColor(.primary)
            }.padding(.horizontal)
            
            List{
                ForEach(pokemonList,id: \.self){ pokemon in
                    NavigationLink {
                        PokemonView(pokemonId: pokemon.num, hasAppeared: .constant(false))
                            .navigationBarBackButtonHidden()
                    } label: {
                        DexNumView(pokemon: pokemon)
                    }

                    
                }
                .onMove(perform:moveList)
                .onDelete(perform:removeList)
                
            }.listStyle(.inset)
                .font(.callout)
            
        }
        .onAppear{
            pokemonList = RealmManager.fetchPokemons()
        }
    }
    func removeList(at offsets: IndexSet) {
        offsets.forEach { RealmManager.deletePokemon(num:pokemonList[$0].num)}
        
   }
    func moveList(indices: IndexSet, newOffset: Int) {
        pokemonList.move(fromOffsets: indices, toOffset: newOffset)
       }
}

#Preview {
    let store = Store(initialState: MyPokemonListFeature.State()) { MyPokemonListFeature() }
    MyPokemonListView(store: store)
}
