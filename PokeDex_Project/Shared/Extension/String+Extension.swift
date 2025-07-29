//
//  String+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/19/25.
//

import Foundation
import SwiftUI

// MARK: - String
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
    
    /// 괄호 삽입
    var insertParentheses: String {
        self.isEmpty ? "" : "(\(self))"
    }
}
