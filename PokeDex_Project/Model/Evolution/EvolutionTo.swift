//
//  EvolutionTree.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation

struct EvolutionTo:Codable,Hashable,Equatable{
    var id: Int?
    var evolTo: [EvolutionTo]
    var image: [String]
    var name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case evolTo = "evol_to"
        case image, name
    }
    init(image: [String], name: String, evolTo: [EvolutionTo] = []) {
        self.image = image
        self.name = name
        self.evolTo = evolTo
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}

