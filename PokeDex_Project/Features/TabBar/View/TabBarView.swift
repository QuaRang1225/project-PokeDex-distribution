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
    let regionStore = Store(initialState: RegionListFeature.State()) { RegionListFeature() }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom) { // ✅ ZStack으로 감쌈
                TabView(selection: viewStore.binding(
                    get: \.selectedTab,
                    send: TabBarFeature.Action.selectTab
                )) {
                    MainView(store: mainStore)
                        .tabItem { Label("Home", systemImage: "house") }
                        .tag(TabBarFeature.Tab.home)
                    
                    Text("asdasd")
                        .tabItem { Label("bookmark", systemImage: "bookmark") }
                        .tag(TabBarFeature.Tab.my)
                }
                .accentColor(.pink)
                Button(action: {
                    viewStore.send(.didTapFloatingButton)
                }) {
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
                    RegionListView(store: regionStore)
                }
            }
        }
    }
}

#Preview {
    let store = Store(initialState: TabBarFeature.State(selectedTab: .home)) { TabBarFeature() }
    TabBarView(store: store)
}
