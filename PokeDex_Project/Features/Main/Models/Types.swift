//
//  Type+Types.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/17/25.
//

import Foundation

/// 포켓몬 타입
struct Types: Equatable {
    var first: String       // 첫번째
    var last: String        // 두번째
    
    init(first: String = "", last: String = "") {
        self.first = first
        self.last = last
    }
}
