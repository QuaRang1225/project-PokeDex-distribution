//
//  PokemonCell.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/19/25.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

/// 포켓몬 리스트 셀
struct PokemonCellView: View {
    typealias PokemonCellStore = ViewStoreOf<PokemonCellFeature>
    let store: StoreOf<PokemonCellFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.delegate(.didTapCell))
            } label: {
                VStack {
                    indexLabel(viewStore: viewStore)
                    pokemonImageView(viewStore: viewStore)
                    pokemonNameLabel(viewStore: viewStore)
                    pokemonTypesLabels(viewStore: viewStore)
                }
            }
        }
    }
}

// MARK: - 포켓몬 셀 컴포넌트
extension PokemonCellView {
    /// 도검 번호 라벨
    private func indexLabel(viewStore: PokemonCellStore) -> some View {
        HStack(spacing: 0){
            KFImage(URL(string: String.mosterBallImageURL))
                .resizable()
                .frame(width: 25,height: 25)
            Text(String(format: "%04d", viewStore.state.pokemon.id))
                .font(.headline)
                .foregroundColor(.primary)
                .bold()
        }
        .offset(x: -5)
    }
    /// 포켓몬 이미지 뷰
    private func pokemonImageView(viewStore: PokemonCellStore) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(height: UIScreen.main.bounds.width/3)
            .foregroundColor(.typeColor(viewStore.state.pokemon.color ?? "").opacity(0.15))
            .overlay {
                KFImage(URL(string: viewStore.pokemon.base?.image ?? ""))
                    .resizable()
                    .padding(.bottom)
            }
    }
    /// 포켓몬 이름
    private func pokemonNameLabel(viewStore: PokemonCellStore) -> some View {
        Text(viewStore.state.pokemon.name ?? "")
            .font(.headline)
            .foregroundColor(.primary)
            .bold()
    }
    /// 포켓몬 타입
    private func pokemonTypesLabels(viewStore: PokemonCellStore) -> some View {
        HStack(spacing: 5){
            ForEach(viewStore.pokemon.base?.types ?? [], id:\.self){ type in
                TypesView(type: type, width: .infinity, height: 20, font: .caption)
            }
        }
        .fontWeight(.black)
        .padding(.bottom, 10)
    }
}

#Preview {
    let pokemon = CustomData.instance.pokemon
    let store = Store(initialState: PokemonCellFeature.State(pokemon: pokemon)) { PokemonCellFeature() }
    PokemonCellView(store: store)
        .frame(width: 150)
}
