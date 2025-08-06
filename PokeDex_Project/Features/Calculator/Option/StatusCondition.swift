//
//  StatusFilter.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/31/25.
//

import Foundation

/// 포켓몬의 주요 상태 이상을 나타내는 열거형
enum StatusCondition: String, CaseIterable, LosslessStringConvertible {
    
    case none = "없음"
    /// 독 상태
    case poison = "독"
    /// 얼음 상태
    case freeze = "얼음"
    /// 마비 상태
    case paralysis = "마비"
    /// 잠듦 상태
    case sleep = "잠듦"
    /// 화상 상태
    case burn = "화상"
    
    /// 한글 상태 이상 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
    
    var description: String {
        self.rawValue
    }
    
    /// 포켓몬 상태 계산
    func calculate(state: inout PokemonAttckState) -> PokemonAttckState {
        switch self {
        case .burn:
            if state.attackedMode == .physical {
                state.result /= 2
            }
            // 물리공격 절반 감소
            return state
        default: return state
        }
    }
    
    // 문자열 → 타입으로 변환
    init?(_ description: String) {
        self.init(rawValue: description)
    }
}
