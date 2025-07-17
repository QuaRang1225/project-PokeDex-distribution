//
//  Varieties.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation

/// 다른모습
struct Varieties: Codable, Hashable {
    var id: String                  // ID
    var abilites: Abilites          // 특성 (숨특 여부, 특성명, 특성 설명)
    var form: Form                  // 폼 (ID, 폼 이미지, 이름)
    var height: Double              // 키
    var stats: [Int]                // 스탯
    var types: [String]             // 타입
    var weight: Double              // 무게

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case abilites, form, height, stats, types, weight
    }
}

