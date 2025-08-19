//
//  RegionListFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/18/25.
//

import Foundation
import ComposableArchitecture

/// 지역 리스트 Feature
struct RegionListFeature: Reducer {
    
    struct State: Equatable {
        var region: RegionFilter = .national
    }
    /// 사용자 액션
    @CasePathable enum ViewAction: Equatable {
        case didTapRegion(RegionFilter)     // 지역 선택
        case didTappedDismissButton         // 닫기 버튼
    }
    /// 상위에서 접근할 Feature 액션
    @CasePathable enum DelegateAction: Equatable {
        case selectedRegion             // 지역 선택 이벤트
        case dismissView                // 닫기 이벤트
    }
    /// 액션 정의
    @CasePathable enum Action: Equatable {
        case view(ViewAction)
        case delegate(DelegateAction)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .view(viewAction):
            switch viewAction {
            case let .didTapRegion(region):
                return didTapRegion(&state, region: region)
            case .didTappedDismissButton:
                return didTapDismissButton(&state)
            }
        default: return .none
        }
    }
    
    /// 지역 버튼 터치 이벤트
    private func didTapRegion(_ state: inout State, region: RegionFilter) -> Effect<Action> {
        state.region = region
        return .send(.delegate(.selectedRegion))
    }
    
    /// 닫기 버튼 터치 이벤트
    private func didTapDismissButton(_ state: inout State) -> Effect<Action> {
        return .send(.delegate(.dismissView))
    }
}
