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
    
    struct State: Equatable {
        var selectedTab: TabFilter = .home
        var showRegionList = false                                                  // 지역 리스트 표시
        
        // 하위 Feature 상태 정의
        var regionListState = RegionListFeature.State()                             // 지역 리스트뷰 상태
        var mainState = MainFeature.State()
        var myPokemonListState = MyPokemonListFeature.State()
    }
    /// 사용자 액션
    @CasePathable enum ViewAction: Equatable {
        case selectTab(tab: TabFilter)                              // 탭바 선택
        case didTapFloatingButton                                   // 플로팅 버튼 액션 추가
    }
    /// 하위 Feature 액션
    @CasePathable enum ChildAction: Equatable {
        case regionListAction(RegionListFeature.Action)             // 지역리스트 Feature 액션
        case mainAction(MainFeature.Action)                         // 메인 Feature 액션
        case myPokemonListAction(MyPokemonListFeature.Action)       //
    }
    /// 액션 정의
    @CasePathable enum Action: Equatable {
        case view(ViewAction)
        case child(ChildAction)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.mainState, action: \.child.mainAction) { MainFeature() }
        Scope(state: \.myPokemonListState, action: \.child.myPokemonListAction) { MyPokemonListFeature() }
        Scope(state: \.regionListState, action: \.child.regionListAction) { RegionListFeature() }

        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case let .selectTab(tab):
                    return setTab(&state, tab: tab)
                case .didTapFloatingButton:
                    return didTapFloatingButton(&state)
                }
            case let .child(childAction):
                switch childAction {
                case let .regionListAction(action):
                    return executeRegionListFeature(&state, action: action)
                default: return .none
                }
            }
        }
    }
    
    /// 탭 선택
    private func setTab(_ state: inout State, tab: TabFilter) -> Effect<Action>{
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
            return .send(.child(.mainAction(.parent(.selectedRegion(region: region)))))
        }
        
        /// 지역리스트 뷰 닫기 이벤트
        func dismissView() -> Effect<Action> {
            state.showRegionList = false
            return .none
        }
    }
}
