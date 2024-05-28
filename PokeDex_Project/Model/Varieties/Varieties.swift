//
//  Varieties.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation


struct Varieties: Codable,Hashable {
    var id: String
    var abilites: Abilites
    var form: Form
    var height: Double
    var stats: [Int]
    var types: [String]
    var weight: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case abilites, form, height, stats, types, weight
    }
}

