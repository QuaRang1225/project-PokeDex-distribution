//
//  CompatibilityCondition.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/5/25.
//

import Foundation

/// 상성 조건
enum CompatibilityCategory: String, CaseIterable {
    case quadruple = "4배"
    case double = "2배"
    case single = "1배"
    case half = "0.5배"
    case halfOfhalf = "0.25배"
    
    /// 한글 공격 종류 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
}
