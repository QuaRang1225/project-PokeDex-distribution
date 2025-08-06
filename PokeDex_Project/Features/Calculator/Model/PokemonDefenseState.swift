//
//  PokemonDefenseState.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/6/25.
//

import Foundation

/// 포켓몬 방어 상태
struct PokemonDefenseState: Equatable {
    let name: String
    let types: [String]
    let pysical: Int
    let special: Int
    var defense: Int
    var result: Double = 1.0
}
