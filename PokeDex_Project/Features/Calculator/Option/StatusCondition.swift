//
//  StatusFilter.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/31/25.
//

import Foundation

/// 포켓몬의 주요 상태 이상을 나타내는 열거형
enum StatusCondition: String, CaseIterable {
    
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
}
