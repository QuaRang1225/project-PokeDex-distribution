//
//  SearchBoardFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/18/25.
//

import Foundation
import ComposableArchitecture

/// 검색 보드 Feature
struct SearchBoardFeature: Reducer {
    
    @ObservableState struct State: Equatable {
        var query: String = ""
        var types: [String] = []
        var isAllTypesSelected: Bool = false
    }
    /// 사용자 액션
    @CasePathable enum ViewAction: Equatable {
        case didTappedResetButton                           // 초기화
        case didTappedTypeButton(_ type: String)            // 타입 삭제
        case didTappedTypeListCell(_ type: String)          // 타입 추가
        case didChangeQuery(_ query: String)                // 쿼리 업데이트
    }
    /// 상위에서 접근할 Feature 액션
    @CasePathable enum DelegateAction: Equatable {
        case didTappedSearchButton                          // 검색
    }
    /// 액션 정의
    @CasePathable enum Action: Equatable {
        case view(ViewAction)
        case delegate(DelegateAction)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .didTappedResetButton:
                    return reset(&state)
                case let .didTappedTypeButton(type):
                    return deleteType(&state, type: type)
                case let .didTappedTypeListCell(type):
                    return addType(&state, type: type)
                case let .didChangeQuery(query):
                    return changeQuery(&state, query: query)
                }
            default:
                return .none
            }
        }
    }
    
    /// 쿼리 업데이트 마다 변경
    private func changeQuery(_ state: inout State, query: String) -> Effect<Action> {
        state.query = query
        return .none
    }
    
    /// 타입 추가
    private func addType(_ state: inout State, type: String) -> Effect<Action> {
        if state.types.count < 2, !state.types.contains(type)  {
            state.types.append(type)
        }
        return .none
    }
    
    /// 타입 삭제
    private func deleteType(_ state: inout State, type: String) -> Effect<Action> {
        state.types.removeAll { $0 == type }
        return .none
    }
    
    /// 초기화
    private func reset(_ state: inout State) -> Effect<Action> {
        state.types.removeAll()
        state.query = ""
        return .none
    }
}
