//
//  TerrainCondition.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 포켓몬 배틀 필드의 상태를 나타내는 열거형
enum TerrainCondition: String, CaseIterable {
    
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
}
