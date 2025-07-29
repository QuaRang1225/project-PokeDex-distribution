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
    typealias MyPokemonListStore = ViewStoreOf<MyPokemonListFeature>
    let store: StoreOf<MyPokemonListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                HStack {
                    titleLabel
                    Spacer()
                    removeAllButton(viewStore: viewStore)
                }
                .padding([.horizontal, .bottom])
                Divider()
                if viewStore.state.isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(2.0)
                    Spacer()
                } else {
                    bookmarkListView(viewStore: viewStore)
                }
            }
            .onAppear {
                viewStore.send(.viewDidLoad)
            }
            .navigationDestination(
                item: viewStore.binding(
                    get: \.pokemonDetailState,
                    send: { _ in .dismissPokemonDetail } // nil로 바꿀 때 액션 전달
                )
            ) { id in
                pokemonDetailsView
            }
        }
    }
}

// MARK: - 북마크 리스트 컴포넌트 정의
private extension MyPokemonListView {
    /// 타이틀 라벨
    var titleLabel: some View {
        Text("내 포켓몬")
            .bold()
            .font(.title)
    }
    /// 전체 삭제 버튼
    func removeAllButton(viewStore: MyPokemonListStore) -> some View {
        Button {
            viewStore.send(.removeAllPokemon)
        } label: {
            Label {
                Text("전체삭제")
                    .font(.caption)
            } icon: {
                Image(systemName: "trash")
            }
        }
        .foregroundColor(.primary)
    }
    /// 리스트 뷰
    func bookmarkListView(viewStore: MyPokemonListStore) -> some View {
        List{
            ForEach(viewStore.pokemons,id: \.self){ pokemon in
                Button {
                    viewStore.send(.didTappedPokemonCell(pokemon.num))
                } label: {
                    DexNumView(pokemon: pokemon)
                }
            }
            .onMove { fromOffset, toOffset in
                viewStore.send(.movePokemon(fromOffset, toOffset))
            }
            .onDelete { offsets in
                viewStore.send(.removePokemon(offsets))
            }
        }
        .listStyle(.inset)
        .font(.callout)
    }
    /// 포켓몬 상세 뷰
    private var pokemonDetailsView: some View {
        IfLetStore(
            store.scope(state: \.pokemonDetailState, action: \.pokemonDetailsAction)
        ) { store in
            PokemonDetailsView(store: store)
                .navigationBarBackButtonHidden(true)
        }
    }
}
#Preview {
    let store = Store(initialState: MyPokemonListFeature.State()) { MyPokemonListFeature() }
    MyPokemonListView(store: store)
}
