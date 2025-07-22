//
//  MainView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

/// 메인 View
struct MainView: View {
    typealias MainStore = ViewStoreOf<MainFeature>
    let store: StoreOf<MainFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        titleLabel(viewStore: viewStore)
                        Spacer()
                        searchButton(viewStore: viewStore)
                    }
                    Divider()
                    pokemonListView(viewStore: viewStore)
                }
                
                if viewStore.state.isLoading {
                    ProgressView()
                        .scaleEffect(2.0)
                }
            }
            .onAppear {
                viewStore.send(.viewDidLoad)
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.showSearchBoard,
                    send: { _ in .dismissSearchView }
                )
            ) {
                Text("asdasdasd")
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .navigationDestination(
                item: viewStore.binding(
                    get: \.selectedPokemonId,
                    send: { _ in .dismissPokemonDetail } // nil로 바꿀 때 액션 전달
                )
            ) { id in
                Text("\(id)")
            }
        }
    }
}

// MARK: - MainView 컴포넌트 정의
extension MainView {
    /// 타이틀 라벨
    private func titleLabel(viewStore: MainStore) -> some View {
        Text(viewStore.state.regionTitle + "도감")
            .bold()
            .font(.title)
            .padding([.leading, .bottom])
    }
    /// 검색 버튼
    private func searchButton(viewStore: MainStore) -> some View {
        Button {
            viewStore.send(.didTappedSearchButton)
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17))
        }
        .foregroundStyle(.primary)
        .padding(.trailing)
    }
    /// 리스트 뷰
    private func pokemonListView(viewStore: MainStore) -> some View {
        
        let columns = Array(repeating: GridItem(.flexible()), count: 3)
        
        return ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: columns) {
                ForEach(
                    store.scope(
                        state: \.pokemonCellStates,
                        action: \.pokemonCellFeature
                    )
                ) { cellStore in
                    WithViewStore(cellStore, observe: { $0 }) { cellViewStore in
                        PokemonCellView(store: cellStore)
                        if viewStore.isLastPokemonReached,
                            viewStore.pokemonCellStates.last?.id == cellViewStore.id {
                            ProgressView()
                                .onVisible {
                                    viewStore.send(.scrollUpList)
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack{
        let store = Store(initialState: MainFeature.State(pokemons: nil, isLoading: false)) { MainFeature() }
        MainView(store: store)
    }
}
