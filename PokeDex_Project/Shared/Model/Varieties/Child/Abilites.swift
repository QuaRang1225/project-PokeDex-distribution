//
//  Abilites.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation

/// 특성
struct Abilites: Codable, Hashable {
    var isHidden: [Bool]        // 숨특 여부
    var name: [String]          // 특성 이름
    var text: [String]          // 특성 설명

    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case name, text
    }
}
