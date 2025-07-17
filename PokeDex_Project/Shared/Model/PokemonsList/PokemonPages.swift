//
//  PokemonPages.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/3/24.
//

import Foundation

struct PokemonPages: Codable {
    let totalCount, totalPages, currentPage, perPage: Int
    let pokemon: [PokemonsList]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case perPage = "per_page"
        case pokemon
    }
}
