//
//  WeatherConditionFilter.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 게임 필드의 날씨 상태를 나타내는 열거형
enum WeatherCondition: String, CaseIterable {
    
    case none = "없음"
    /// 모래바람이 부는 상태
    case sandstorm = "모래바람"
    
    /// 눈이 내리는 상태 (설경)
    case snow = "설경"
    
    /// 쾌청하여 햇살이 강한 상태
    case sunny = "쾌청"
    
    /// 비가 내리는 상태
    case rain = "비바라기"
    
    /// 한글 날씨 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
    
    /// 포켓몬 상태 계산
    func calculate(state: inout PokemonState) -> PokemonState {
        switch self {
        case .sunny:
            if TypeFilter(rawValue: state.type) == .fire {
                state.result *= 1.5
            } else if TypeFilter(rawValue: state.type) == .water {
                state.result /= 2.0
            }
            // 불꽅 타입 위력 1.5배 증가
            // 물 타입 위력 0.5배로 감소
            return state
        case .rain:
            if TypeFilter(rawValue: state.type) == .water {
                state.result *= 1.5
            } else if TypeFilter(rawValue: state.type) == .fire {
                state.result /= 2.0
            }
            // 물타입 위력 1.5배 증가
            // 불꽃 타입 위력 0.5배로 감소
            return state
        default: return state
        }
    }
    
    /// 원시값 -> case
    init?(rawValue: String) {
        if let match = WeatherCondition.allCases.first(where: { $0.rawValue == rawValue }) {
            self = match
        } else {
            return nil
        }
    }
}
