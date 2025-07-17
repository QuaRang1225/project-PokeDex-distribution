//
//  TabBarFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/17/25.
//

import Foundation
import ComposableArchitecture

/// 탭바 Feature
struct TabBarFeature: Reducer {
    enum Tab {
        case home, search, profile
    }
    
    struct State: Equatable {
        var selectedTab: Tab = .home
    }
    
    enum Action: Equatable {
        case selectTab(tab: Tab)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectTab(tab):
           setTab(state: &state, tab)
        }
    }
    
    /// 탭 선택
    private func setTab(state: inout State, _ tab: Tab) -> Effect<Action>{
        state.selectedTab = tab
        return .none
    }
}
