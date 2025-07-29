//
//  TabBarView.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/17/25.
//

import SwiftUI
import ComposableArchitecture

struct TabBarView: View {
    let store: StoreOf<TabBarFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom) { 
                TabView(selection: viewStore.binding(
                    get: \.selectedTab,
                    send: TabBarFeature.Action.selectTab
                )) {
                    MainView(
                        store: store.scope(
                            state: \.mainState,
                            action: \.mainAction
                        )
                    )
                    .tabItem {
                        Label(TabFilter.home.name, systemImage: TabFilter.home.image)
                    }
                    .tag(TabFilter.home)
                    
                    MyPokemonListView(
                        store: store.scope(
                            state: \.myPokemonListState,
                            action: \.myPokemonListAction
                        )
                    )
                    .tabItem {
                        Label(TabFilter.my.name, systemImage: TabFilter.my.image)
                    }
                    .tag(TabFilter.my)
                }
                .accentColor(.pink)
                Button {
                    viewStore.send(.didTapFloatingButton)
                } label: {
                    Image(systemName: "circle.grid.3x3")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 65, height: 65)
                        .background(Color.pink)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.bottom, 10)
                
                if viewStore.state.showRegionList {
                    RegionListView(store: store.scope(state: \.regionListState, action: \.regionListAction))
                }
            }
        }
    }
}

#Preview {
    let store = Store(initialState: TabBarFeature.State(selectedTab: .home)) { TabBarFeature() }
    TabBarView(store: store)
}
