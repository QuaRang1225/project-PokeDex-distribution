//
//  Abilites.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation

// MARK: - Abilites
struct Abilites: Codable,Hashable {
    var isHidden: [Bool]
    var name, text: [String]

    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case name, text
    }
}
