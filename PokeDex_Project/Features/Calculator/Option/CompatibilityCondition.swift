//
//  CompatibilityCondition.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/5/25.
//

import Foundation

/// 상성 조건
enum CompatibilityCategory: String, CaseIterable {
    /// 4배
    case quadruple = "효과가 매우 굉장함 (x4)"
    /// 2배
    case double = "효과가 굉장함 (x2)"
    /// 1배
    case single = "기본 (x1)"
    /// 0.5배
    case half = "효과가 별로다 (x0.5)"
    /// 0.25배
    case halfOfhalf = "효과가 매우 별로다 (x0.25)"
    /// 0배
    case none = "효과가 없다 (x0)"
    
    /// 한글 공격 종류 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
    
    /// 곱수
    var multiple: Double {
        switch self {
        case .quadruple:
            return 4
        case .double:
            return 2
        case .single:
            return 1
        case .half:
            return 0.5
        case .halfOfhalf:
            return 0.25
        case .none:
            return 0
        }
    }
    
    /// 포켓몬 상태 계산
    func calculate(state: inout PokemonState) -> PokemonState {
        switch self {
        case .quadruple:
            state.result *= 4
            return state
        case .double:
            state.result *= 2
            return state
        case .single:
            return state
        case .half:
            state.result *= 0.5
            return state
        case .halfOfhalf:
            state.result *= 0.25
            return state
        case .none:
            state.result *= 0
            return state
        }
    }
    
    /// 원시값 -> case
    init?(rawValue: String) {
        if let match = CompatibilityCategory.allCases.first(where: { $0.rawValue == rawValue }) {
            self = match
        } else {
            return nil
        }
    }
}
