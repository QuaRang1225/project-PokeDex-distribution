//
//  DexNumView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/21/24.
//

import SwiftUI
import Kingfisher

/// 포켓몬 리스트 셀 뷰
struct MyPokemonListCellView: View {
    let pokemon: RealmPokemon
    var body: some View {
        VStack{
            HStack{
                pokemonImageView
                VStack(alignment: .leading,spacing: 0) {
                    indexLabel
                    nameLabel
                }
                Spacer()
                typesLabel
            }
            .font(.caption)
            statsLabel
        }
    }
}

// MARK: - 내 포켓몬 셀 뷰
extension MyPokemonListCellView {
    /// 이미지 뷰
    var pokemonImageView: some View {
        KFImage(URL(string:pokemon.image))
            .resizable()
            .frame(width: 50,height: 50)
    }
    /// 번호 라벨
    var indexLabel: some View {
        HStack(spacing: 0){
            KFImage(URL(string: String.mosterBallImageURL))
            Text(String(format : "%04d",pokemon.num))
        }
    }
    /// 이름 라벨
    var nameLabel: some View {
        Text(pokemon.name)
            .padding(.leading,5)
    }
    /// 타입 라벨
    var typesLabel: some View {
        ForEach(pokemon.types,id:\.self){ type in
            TypesView(type: type, width: 70, height: 20, font: .caption)
        }
    }
    /// 스탯 라벨
    @ViewBuilder
    var statsLabel: some View {
        if let stats = pokemon.stats{
            HStack{
                ForEach(Array(zip(StatsFilter.allCases, stats)), id:\.0){ name, stat in
                    VStack {
                        Text(name.rawValue)
                        Text("\(stat)")
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    MyPokemonListCellView(
        pokemon: RealmPokemon(
            id: "dasasda",
            num: 1,
            name: "안뇽",
            image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/10080.png",
            types: ["독", "풀"],
            stats: [1, 2, 3, 4, 5, 6, 7]
        )
    )
}
