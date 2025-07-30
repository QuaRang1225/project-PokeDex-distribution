//
//  PokemonInfo.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/30/25.
//

import Foundation

/// 종족값 계산을 위한 포켓몬 정보
struct PokemonInfo: Equatable {
    var id: Int                 // 도감 넘버
    var name: String            // 포켓몬 이름
    var image: String           // 포켓몬 이미지
    var stats: [Int]            // 포켓몬 스탯
    var types: [String]         // 포켓몬 타입 배열
}
