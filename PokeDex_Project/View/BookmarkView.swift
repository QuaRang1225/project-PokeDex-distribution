//
//  BookmarkView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import SwiftUI
import Kingfisher

struct BookmarkView: View {
    let monsterball = "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"
    @State var pokemonList:[RealmPokemon] = []
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
                    HStack{
                        KFImage(URL(string:pokemon.image))
                            .resizable()
                            .frame(width: 50,height: 50)
                        VStack(alignment: .leading,spacing: 0) {
                            HStack(spacing: 0){
                                KFImage(URL(string: monsterball))
                                Text(String(format : "%04d",pokemon.num))
                            }
                            Text(pokemon.name).padding(.leading,5)
                        }
                        Spacer()
                        ForEach(pokemon.types,id:\.self){ type in
                            TypesView(type: type, width: 60, height: 20, font: .callout)
                        }
                    }
                }
                .onMove(perform:moveList)
                .onDelete(perform:removeList)
                
            }.listStyle(.inset)
            
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
    BookmarkView(pokemonList: [RealmPokemon(id: "dasasda", num: 1, name: "안뇽", image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/10080.png", types: ["독","풀"])])
}
