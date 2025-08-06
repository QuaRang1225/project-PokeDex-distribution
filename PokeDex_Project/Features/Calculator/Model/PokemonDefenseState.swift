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
    let hp: Int                                    // 체력
    let pysical: Int                               // 방어
    let special: Int                               // 특방
    
    init(type: [String], name: String, hp: Int, pysical: Int, special: Int) {
        self.name = name
        self.hp = hp
        self.pysical = pysical
        self.special = special
        self.types = type
    }
}
