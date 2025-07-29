//
//  TextEntries.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/1/24.
//

import Foundation

/// 도감 설명
struct TextEntries: Codable, Hashable, Equatable {
    var text: [String]          // 설명
    var version : [String]      // 버전
    
    /// 튜플로 반환
    var items: [(String, String, Bool?)] {
        return zip(version, text)
            .map { ($0, $1, nil) }
    }
}
