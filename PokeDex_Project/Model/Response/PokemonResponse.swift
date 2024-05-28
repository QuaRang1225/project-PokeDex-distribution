//
//  Response.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/1/24.
//

import Foundation

struct PokemonResponse: Codable {
    let status: Int
    let data: Pokemons
    let message : String
}
