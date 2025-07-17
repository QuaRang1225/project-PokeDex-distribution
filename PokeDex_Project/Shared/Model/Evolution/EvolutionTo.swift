//
//  EvolutionTree.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation

/// 진화트리 구조 요소
struct EvolutionTo: Codable, Hashable, Equatable {
    
    var id: Int?    /// ID
    var evolTo: [EvolutionTo]   /// 진화할  포켓몬
    var image: [String]     /// 이미지
    var name: String        // 이름

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
}

