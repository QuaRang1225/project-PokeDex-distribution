//
//  TextEntries.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/1/24.
//

import Foundation

/// 도감 설명
struct TextEntries: Codable, Equatable {
    var text: [String]          // 설명
    var version : [String]      // 버전
}
