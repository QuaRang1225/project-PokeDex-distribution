//
//  TerrainCondition.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 포켓몬 배틀 필드의 상태를 나타내는 열거형
enum TerrainCondition: String, CaseIterable {
    
    case none = "없음"
    /// 그래스필드
    case grassy = "그래스필드"
    
    /// 미스트필드
    case misty = "미스트필드"
    
    /// 사이코필드
    case psychic = "사이코필드"
    
    /// 일렉트릭필드
    case electric = "일렉트릭필드"
    
    /// 한글 필드 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
    
    /// 포켓몬 상태 계산
    func calculate(state: inout PokemonState) -> PokemonState {
        switch self {
        case .none:
            return state
        case .grassy:
            if TypeFilter(rawValue: state.type) == .grass {
                state.result *= 1.3
            }
            // 풀타입 위력 1.5배 증가
            return state
        case .misty:
            if TypeFilter(rawValue: state.type) == .dragon {
                state.result /= 2
            }
            // 드래곤 타입 위력 절반
            return state
        case .psychic:
            if TypeFilter(rawValue: state.type) == .psychic {
                state.result *= 1.3
            }
            // 에스퍼 타입 위력 1.3배 증가
            return state
        case .electric:
            if TypeFilter(rawValue: state.type) == .electric {
                state.result *= 1.3
            }
            // 전기 타입 위력 1.3배 증가
            return state
        }
        
    }
    /// 원시값 -> case
    init?(rawValue: String) {
        if let match = TerrainCondition.allCases.first(where: { $0.rawValue == rawValue }) {
            self = match
        } else {
            return nil
        }
    }
}
