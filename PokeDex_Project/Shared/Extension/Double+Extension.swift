//
//  Double+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

extension Double {
    /// 랭크업 계산
    var calculateRankMultiplier: Double {
        switch self {
        case 1...6:
            return Double(2 + self) / 2.0
        case -6 ... -1:
            return 2.0 / Double(2 - self) // 음수 처리 주의
        default:
            return 1.0 // 0랭크일 경우 보정 없음
        }
    }
}
