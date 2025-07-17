//
//  Pokemon.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 4/30/24.
//

import Foundation

/// 포켓몬 상세정보
struct Pokemon: Codable, Hashable, Equatable {
    var id: Int                      // ID - 전국도감 번호
    var color: String?               // 색상 - 포켓몬 고유 색상
    var base: Base?                  // 기본 모습정보 (이미지, 타입)
    var captureRate: Int?            // 포획율
    var dex: [Dex]?                  // 도감 정보 (지방, 지방 번호)
    var eggGroup: [String]?          // 알 그룹
    var evolutionTree: Int?          // 진화트리 번호
    var formsSwitchable: Bool?       // 폼 체인지 유무
    var genderRate: Int?             // 성비
    var genra: String?               // 타이틀 ex: 이상해씨) -> 씨앗포켓몬
    var hatchCounter: Int?           // 부화수
    var name: String?                // 이름
    var textEntries: TextEntries?    // 도감설명
    var varieties: [String]?         // 다른모습 메가진화의 경우 이상해씨 -> [venusaur, venusaur-mega]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case color = "color"
        case base = "base"
        case captureRate = "capture_rate"
        case dex = "dex"
        case eggGroup = "egg_group"
        case evolutionTree = "evolution_tree"
        case formsSwitchable = "forms_switchable"
        case genderRate = "gender_rate"
        case genra = "genra"
        case hatchCounter = "hatch_counter"
        case name = "name"
        case textEntries = "text_entries"
        case varieties = "varieties"
    }
}

