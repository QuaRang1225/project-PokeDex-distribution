//
//  TerrainCondition.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 포켓몬 배틀 필드의 상태를 나타내는 열거형
enum FieldCondition: String, CaseIterable, LosslessStringConvertible {
    
    case none = "없음"
    /// 그래스필드
    case grassy = "그래스필드"
    
    /// 미스트필드
    case misty = "미스트필드"
    
    /// 사이코필드
    case psychic = "사이코필드"
    
    /// 일렉트릭필드
    case electric = "일렉트릭필드"
    
    var description: String {
        self.rawValue
    }
    
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
            if state.type == .grass {
                state.result *= 1.3
            }
            // 풀타입 위력 1.5배 증가
            return state
        case .misty:
            if state.type == .dragon {
                state.result /= 2
            }
            // 드래곤 타입 위력 절반
            return state
        case .psychic:
            if state.type == .psychic {
                state.result *= 1.3
            }
            // 에스퍼 타입 위력 1.3배 증가
            return state
        case .electric:
            if state.type == .electric {
                state.result *= 1.3
            }
            // 전기 타입 위력 1.3배 증가
            return state
        }
    }
    
    // 문자열 → 타입으로 변환
    init?(_ description: String) {
        self.init(rawValue: description)
    }
}
