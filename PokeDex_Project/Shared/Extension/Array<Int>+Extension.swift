//
//  Array<Int>+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/24/25.
//

import Foundation

// MARK: - [Int]
extension Array<Int> {
    /// 마지막 요소는 해당 배열의 합계 추가
    var addSum: [Int] {
        let sum = self.reduce(0, +)
        return self + [sum]
    }
}
