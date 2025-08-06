//
//  AttackFilter.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/31/25.
//

import Foundation

/// 포켓몬 기술의 공격 종류를 나타내는 열거형
enum AttackCondition: String, CaseIterable {
    
    /// 물리 공격
    case physical = "물리공격"
    /// 특수 공격
    case special = "특수공격"
    
    /// 한글 공격 종류 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
}
