//
//  PokemonState.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/5/25.
//

import Foundation

/// 포켓몬 상태
struct PokemonState: Equatable {
    let name: String                                // 이름
    let types: [String]                             // 타입
    var power: Int                                  // 위력
    var type: String                                // 선택한 타입
    var multiple: String                            // 효과
    var rankUp: String                              // 랭크업
    var isTherastal: Bool                           // 테라스탈 여부
    var attackedMode: AttackCategory                // 물리/특공
    var ability: String                             // 특성
    var status: String                              // 상태이상
    var weather: String                             // 날씨
    var field: String                               // 필드
    var item: String                                // 아이템
    var battleModifier: [BattleModifierType: Bool]  // 기타
    var result: Double = 1.0
    
    init(type: [String], name: String) {
        self.name = name
        self.power = 0
        self.type = TypeFilter.normal.rawValue
        self.types = type
        self.multiple = CompatibilityCategory.single.koreanName
        self.rankUp = "\(0)"
        self.isTherastal = false
        self.attackedMode = .physical
        self.ability = PokemonAbility.none.koreanName
        self.status = StatusCondition.none.koreanName
        self.weather = WeatherCondition.none.koreanName
        self.field = TerrainCondition.none.koreanName
        self.item = PokemonItem.none.koreanName
        self.battleModifier = Dictionary(uniqueKeysWithValues: BattleModifierType.allCases.map { ($0, false)})
    }
}
