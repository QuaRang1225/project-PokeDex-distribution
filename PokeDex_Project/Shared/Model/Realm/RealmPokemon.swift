//
//  RealmPokemon.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation

/// RealmDB에 저장할 포켓몬 정보
struct RealmPokemon: Hashable {
    var id: String          // ID
    var num: Int            // 도감번호
    var name: String        // 이름
    var image: String       // 이미지
    var types: [String]     // 타입
    var stats: [Int]?       // 스탯 정보
}
