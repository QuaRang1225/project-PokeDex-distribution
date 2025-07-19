//
//  PokemonPages.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/3/24.
//

import Foundation

/// 리스트 형태의 반환 데이터를 디코딩하기 위함
struct PokemonList: Codable, Hashable, Equatable {
    let totalCount: Int         // 총 개수
    let totalPages: Int         // 총 페이지 수
    let currentPage: Int        // 현재 페이지
    let perPage: Int            // 이전 페이지
    var pokemons: [Pokemon]      // 포켓몬 리스트
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case perPage = "per_page"
        case pokemons = "pokemon"
    }
}
