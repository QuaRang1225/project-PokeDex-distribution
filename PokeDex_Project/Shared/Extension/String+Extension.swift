//
//  String+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/19/25.
//

import Foundation
import SwiftUI

// MARK: - 문자열 관련 메서드 추가 구현
extension String {
    static let mosterBallImageURL: String = "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"
    
    /// 문자열 -> 색상
    var typeColor: Color {
        return Color(self)
    }

    /// 문자열에서 숫자 추출
    var extractNumber: Int? {
        let pattern = "\\d+"
        if let range = self.range(of: pattern, options: .regularExpression) {
            return Int(self[range])
        }
        return nil
    }
}
