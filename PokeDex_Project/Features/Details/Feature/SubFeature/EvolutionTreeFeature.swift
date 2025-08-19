//
//  EvolutionTreeFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/25/25.
//

import Foundation
import ComposableArchitecture

/// 진화트리 Feature
struct EvolutionTreeFeature: Reducer {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: EvolutionTo.ID { node.image.first!.extractNumber! }
        var node: EvolutionTo
        var children: IdentifiedArrayOf<State> = []
    }
    /// 사용자 액션
    @CasePathable enum ViewAction: Equatable {
        case viewDidLoad                                        // 뷰 등장
        case didTappedEvolutionTo                               // 진화트리 셀 터치
    }
    /// 상위에서 접근할 Feature 액션
    @CasePathable enum DelegateAction: Equatable {
        case children(IdentifiedActionOf<EvolutionTreeFeature>) // 상위 feture로 이벤트 전달
        case eventEvolution(_ id: Int?)
    }
    /// 액션 정의
    @CasePathable indirect enum Action: Equatable {
        case view(ViewAction)
        case delegate(DelegateAction)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .viewDidLoad:
                    return setEvolutionTree(&state)
                case .didTappedEvolutionTo:
                    return fetchEvolutionTree(&state)
                }
            case let .delegate(delegateAction):
                switch delegateAction {
                case let .children(.element(_, .delegate(delegateAction))):
                    return .send(.delegate(delegateAction))
                default: return .none
                }
            }
        }
        .forEach(\.children, action: \.delegate.children) {
            Self() // ✅ 재귀적으로 자기 자신을 연결
        }
    }
    
    /// 자식 노드 설정 (예: API 요청 이후)
    private func fetchEvolutionTree(_ state: inout State) -> Effect<Action> {
        let id = state.node.image.first?.extractNumber ?? 0
        return .send(.delegate(.eventEvolution(id)))
    }
    /// 진화트리 세팅
    private func setEvolutionTree(_ state: inout State) -> Effect<Action> {
        let nodes = state.node.evolTo
        state.children = IdentifiedArrayOf(
            uniqueElements: nodes.map { State(node: $0) }
        )
        return .none
    }
}
