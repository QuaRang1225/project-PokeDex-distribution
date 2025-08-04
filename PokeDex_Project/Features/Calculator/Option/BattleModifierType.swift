//
//  BattleModifierType.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 전투 중 적용될 수 있는 다양한 보정 효과의 종류를 나타내는 열거형
enum BattleModifierType: String, CaseIterable {
    
    case criticalHit = "급소"
    case charge = "충전"
    case helpingHand = "도우미"
    case battery = "배터리"
    case powerSpot = "파워스폿"
    case friendGuard = "프렌드가드"
    case flowerGift = "플라워기프트"
    case fairyAura = "페어리오라"
    case darkAura = "다크오라"
    case auraBreak = "오라브레이크"
    case tabletsOfRuin = "재앙의목간"
    case swordOfRuin = "재앙의검"
    case vesselOfRuin = "재앙의그릇"
    case beadsOfRuin = "재앙의구슬"
    case steelySpirit = "강철정신"
    
    /// 한글 보정 효과 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
}
