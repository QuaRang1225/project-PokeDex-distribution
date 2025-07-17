//
//  Dex.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/1/24.
//

import Foundation

/// 지역별 번호 및 지방 이름
struct Dex: Codable, Hashable {
    var num : Int               // 도감 번호
    var region : String         // 번호에 해당되는 지방
}
