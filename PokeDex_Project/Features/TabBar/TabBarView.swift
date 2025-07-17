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
    let mainStore = Store(initialState: MainFeature.State()) { MainFeature() }

    var body: some View {
        WithViewStore(store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(
                get: \.self,
                send: TabBarFeature.Action.selectTab
            )) {
                MainView(store: mainStore)
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(TabBarFeature.Tab.home)
            }
        }
    }
}

#Preview {
    let store = Store(initialState: TabBarFeature.State(selectedTab: .home)) { TabBarFeature() }
    TabBarView(store: store)
}
