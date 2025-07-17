//
//  PokemonsList.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/3/24.
//

import Foundation

struct PokemonsList:Codable,Hashable{
    
    let id: Int
    let color, name: String
    let base: ListBase
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case color, name, base
    }
}
