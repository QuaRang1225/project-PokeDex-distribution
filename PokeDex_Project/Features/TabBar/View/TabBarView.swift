//
//  TabBarView.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/17/25.
//

import SwiftUI
import ComposableArchitecture

/// 탭바 뷰
struct TabBarView: View {
    typealias TabBarStore = ViewStoreOf<TabBarFeature>
    let store: StoreOf<TabBarFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom) { 
                TabView(selection: viewStore.binding(
                    get: \.selectedTab,
                    send: TabBarFeature.Action.selectTab
                )) {
                    mainView
                    myPokemonListView
                }
                .accentColor(.pink)
                floatingButton(viewStore: viewStore)
                regionListView(viewStore: viewStore)
            }
        }
    }
}
// MARK: - 탭바 뷰 컴포넌트 정의
private extension TabBarView {
    /// 메인 화면
    var mainView: some View {
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
    }
    /// 북마크 리스트 뷰
    var myPokemonListView: some View {
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
    /// 플로팅 버튼
    @ViewBuilder
    func floatingButton(viewStore: TabBarStore) -> some View {
        if viewStore.state.selectedTab == .home {
            Button {
                viewStore.send(.didTapFloatingButton)
            } label: {
                Image(systemName: "circle.grid.3x3")
                    .font(.system(size: isIpad ? 24: 12, weight: .bold))
                    .foregroundStyle(isIpad ? .pink : .white)
                    .frame(width: 65, height: 65)
                    .background {
                        if !isIpad {
                            Color.pink
                        }
                    }
                    .clipShape(Circle())
                    .shadow(radius: isIpad ? 0 : 4)
            }
            .padding(.bottom, 10)
            .frame(
                maxWidth: isIpad ? .infinity : nil,
                maxHeight: isIpad ? .infinity : nil,
                alignment: isIpad ? .topTrailing : .center
            )
        }
    }
    /// 지역리스트
    @ViewBuilder
    func regionListView(viewStore: TabBarStore) -> some View {
        if viewStore.state.showRegionList {
            RegionListView(store: store.scope(state: \.regionListState, action: \.regionListAction))
        }
    }
}
#Preview {
    let store = Store(initialState: TabBarFeature.State(selectedTab: .home)) { TabBarFeature() }
    TabBarView(store: store)
}
