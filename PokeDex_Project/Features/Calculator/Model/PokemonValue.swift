//
//  PokemonValue.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 결정력/내구력 계산을 위해 넘겨줄 정보
struct PokemonValue: Equatable {
    let type: [String]
    let pysical: Int
    let special: Int
}
