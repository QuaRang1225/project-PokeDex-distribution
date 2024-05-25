//
//  DexNumView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/21/24.
//

import SwiftUI
import Kingfisher

struct DexNumView: View {
    let pokemon:RealmPokemon
    let monsterball = "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"
    var body: some View {
        VStack{
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
                    TypesView(type: type, width: 70, height: 20, font: .caption)
                }
            }
            .font(.caption)
            if let stats = pokemon.stats{
                HStack{
                    ForEach(Array(zip(StatsFilter.allCases,stats)),id:\.0){ name,stat in
                        VStack{
                            Text(name.rawValue)
                            Text("\(stat)")
                        }.frame(maxWidth: .infinity)
                    }
                }.padding(.top)
            }
        }
    }
}

#Preview {
    DexNumView(pokemon: RealmPokemon(id: "dasasda", num: 1, name: "안뇽", image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/10080.png", types: ["독","풀"],stats: [1,2,3,4,5,6,7]))
}
