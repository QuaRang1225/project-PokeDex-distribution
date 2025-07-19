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
        case home, my
        
        var name: String {
            switch self {
            case .home: "도감"
            case .my: "북마크"
            }
        }
        
        var image: String {
            switch self {
            case .home: "book.closed.fill"
            case .my: "bookmark"
            }
        }
    }
    
    struct State: Equatable {
        var selectedTab: Tab = .home
        var showRegionList = false                                                  // 지역 리스트 표시
        
        // 하위 Feature 상태 정의
        var regionListState = RegionListFeature.State()                             // 지역 리스트뷰 상태
        var mainState = MainFeature.State()
    }
    
    @CasePathable enum Action: Equatable {
        case selectTab(tab: Tab)
        case didTapFloatingButton                                   // 플로팅 버튼 액션 추가
        
        case regionListAction(RegionListFeature.Action)             // 하위 Feature 액션
        case mainAction(MainFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.mainState, action: \.mainAction) { MainFeature() }
        Scope(state: \.regionListState, action: \.regionListAction) { RegionListFeature() }

        Reduce { state, action in
            switch action {
            case let .selectTab(tab):
                return setTab(&state, tab: tab)
            case .didTapFloatingButton:
                return didTapFloatingButton(&state)
            case let .regionListAction(action):
                return executeRegionListFeature(&state, action: action)
            default: return .none
            }
        }
    }
    
    /// 탭 선택
    private func setTab(_ state: inout State, tab: Tab) -> Effect<Action>{
        state.selectedTab = tab
        return .none
    }
    
    private func didTapFloatingButton(_ state: inout State) -> Effect<Action>{
        state.showRegionList = true
        return .none
    }
}

// MARK: - 지역 리스트 이벤트
extension TabBarFeature {
    /// 지역 리스트 이벤트 실행자
    private func executeRegionListFeature(_ state: inout State, action: RegionListFeature.Action) -> Effect<Action> {
        switch action {
        case .delegate(.selectedRegion):
            return selectedRegion()
        case .delegate(.dismissView):
            return dismissView()
        default: return .none
        }
        
        /// 지역 선택 이벤트
        func selectedRegion() -> Effect<Action> {
            let region = state.regionListState.region.rawValue        // 지역 리스트 피쳐의 state 값 가져옴
            state.showRegionList = false
            return .send(.mainAction(.delegate(.selectedRegion(region: region))))
        }
        
        /// 지역리스트 뷰 닫기 이벤트
        func dismissView() -> Effect<Action> {
            state.showRegionList = false
            return .none
        }
    }
}
