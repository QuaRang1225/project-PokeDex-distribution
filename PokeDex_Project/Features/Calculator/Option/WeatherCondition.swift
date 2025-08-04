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
}
