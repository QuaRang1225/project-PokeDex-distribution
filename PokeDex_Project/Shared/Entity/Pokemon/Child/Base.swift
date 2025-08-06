//
//  Base.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/1/24.
//

import Foundation

/// 포켓몬의 기본모습
/// 다른 모습, 리전폼이 이 있던 없던 이곳에 기본모습이 저장됨
struct Base: Codable, Hashable, Equatable {
    var image : String      // 이미지
    var types : [String]    // 타입 배열
    var num: Int?           // 도감 넘버 (전국도감)
}


