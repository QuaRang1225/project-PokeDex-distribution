//
//  PokemonDefenseState.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/6/25.
//

import Foundation

/// 포켓몬 방어 상태
struct PokemonDefenseState: Equatable {
    let name: String                               // 이름
    let types: [String]                            // 타입
    let pysical: Int                               // 방어
    let special: Int                               // 특방
    var defenseMode: AttackCondition               // 방어/특방
    var result: Double = 1.0
    
    init(type: [String], name: String, pysical: Int, special: Int) {
        self.name = name
        self.pysical = pysical
        self.special = special
        self.types = type
        self.defenseMode = .physical
    }
}
