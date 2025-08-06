//
//  BattleModifierType.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 전투 중 적용될 수 있는 다양한 보정 효과의 종류를 나타내는 열거형
enum BattleCondition: String, CaseIterable, LosslessStringConvertible {
    
    case criticalHit = "급소"     // 1.5
    case recoid = "반동기술"
    case punch = "펀치기술"
    case contact = "접촉기술"
    case cutting = "베기계열"
    case bitting = "물기계열"
    case sounding = "소리계열"
    case wave = "파동계열"
    case sideEffect = "추가효과기술"
    case change = "상대교체"
    case charge = "충전"
    case withMinus = "마이너스"
    case withPlus = "플러스"
    case helpingHand = "도우미"    // 위력 1.5배
    case battery = "배터리"        // 위력 1.3배
    case powerSpot = "파워스폿"     // 위력 1.3배
    case flowerGift = "플라워기프트"  // 공격/특방 1.5배
    case fairyAura = "페어리오라"    // 페어리 위력 1.3배
    case darkAura = "다크오라"      // 악 위력 1.3배
    case auraBreak = "오라브레이크"   // 악/페어리 위력 0.7배
    case tabletsOfRuin = "재앙의목간"    // 공격 0.75배
    case vesselOfRuin = "재앙의그릇"  // 특공 0.75배
    
    var description: String {
        self.rawValue
    }
    
    /// 한글 보정 효과 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
    
    /// 포켓몬 상태 계산
    func calculate(state: inout PokemonState) -> PokemonState {
        switch self {
        case .criticalHit:
            state.result *= 1.5
            return state
        case .helpingHand:
            state.result *= 1.5
            return state
        case .battery:
            if state.attackedMode == .special {
                state.result *= 1.3
            }
            return state
        case .powerSpot:
            state.result *= 1.3
            return state
        case .flowerGift:
            if state.attackedMode == .physical {
                state.result *= 1.5
            }
            return state
        case .fairyAura:
            if state.type == .fairy {
                state.result *= 1.3
            }
            return state
        case .darkAura:
            if state.type == .dark {
                state.result *= 1.3
            }
            return state
        case .auraBreak:
            if state.type == .fairy || state.type == .dark {
                state.result *= 0.7
            }
            return state
        case .tabletsOfRuin:
            if state.attackedMode == .physical {
                state.result *= 0.75
            }
            return state
        case .vesselOfRuin:
            if state.attackedMode == .special {
                state.result *= 0.75
            }
            return state
        default:
            return state
        }
    }
    
    // 문자열 → 타입으로 변환
    init?(_ description: String) {
        self.init(rawValue: description)
    }
}
