//
//  PokemonsListResponse.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/3/24.
//

import Foundation

struct PokemonListResponse: Codable {
    let status: Int
    let data: PokemonPages
    let message : String
}
