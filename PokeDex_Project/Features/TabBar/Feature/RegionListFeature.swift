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
    
    enum Action: Equatable {
        // 행위 핵션
        case didTapRegion(RegionFilter)     // 지역 선택
        case didTappedDismissButton         // 닫기 버튼
        case delegate(Delegate)             // 결과 액션
        
        enum Delegate: Equatable {
            case selectedRegion             // 지역 선택 이벤트
            case dismissView                // 닫기 이벤트
        }
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .didTapRegion(region):
            didTapRegion(&state, region: region)
        case .didTappedDismissButton:
            didTapDismissButton(&state)
        case .delegate:
            .none
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
