//
//  Int+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/24/25.
//

import Foundation

// MARK: - Int
extension Int {
    /// 성비 반환
    var genderRate: [String] {
        var genderInfo: [String]

        if self == -1 {
            genderInfo = ["성비 없음"]
        } else {
            let femaleRate = Double(self) / 8 * 100
            let maleRate = 100 - femaleRate
            genderInfo = [
                "수컷: \(String(format: "%.1f", maleRate))%",
                "암컷: \(String(format: "%.1f", femaleRate))%"
            ]
        }
        return genderInfo
    }
}
