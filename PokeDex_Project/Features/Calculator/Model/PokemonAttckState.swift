//
//  PokemonState.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/5/25.
//

import Foundation

/// 포켓몬 공격 상태
struct PokemonAttckState: Equatable {
    let name: String                                // 이름
    let types: [String]                             // 타입
    let pysical: Int                                // 물리
    let special: Int                                // 특수
    var power: Int                                  // 위력
    var rankUp: String                              // 랭크업
    var isTherastal: Bool                           // 테라스탈 여부
    var type: TypeFilter                            // 선택한 타입
    var compatibility: CompatibilityCondition       // 효과
    var attackedMode: AttackCondition               // 물리/특공
    var ability: AbilityCondition                   // 특성
    var status: StatusCondition                     // 상태이상
    var weather: WeatherCondition                   // 날씨
    var field: FieldCondition                       // 필드
    var item: ItemCondition                         // 아이템
    var battleModifier: [BattleCondition: Bool]     // 기타
    var result: Double = 1.0
    
    /// 자속 여부
    var isStab: Bool {
        types.contains(type.rawValue)
    }
    
    /// 자속 보정
    var stab: Double {
        isStab ? 1.5 : 1.0
    }
    
    /// 테라스탈 여부
    var isTherastalMutiple: Double {
        if isStab {
            isTherastal ? (4/3) : 1.0
        } else {
            isTherastal ? 1.5 : 1.0
        }
    }
    
    /// 추가 계산( 자속 x 테라스탈 x 기술위력 x 랭크업)
    var addMutiple: Double {
        stab * isTherastalMutiple * Double(power) * (Double(rankUp)?.calculateRankMultiplier ?? 0)
    }
    
    init(type: [String], name: String, pysical: Int, special: Int) {
        self.name = name
        self.pysical = pysical
        self.special = special
        self.types = type
        self.power = 0
        self.type = .normal
        self.compatibility = .single
        self.rankUp = "\(0)"
        self.isTherastal = false
        self.attackedMode = .physical
        self.ability = .none
        self.status = .none
        self.weather = .none
        self.field = .none
        self.item = .none
        self.battleModifier = Dictionary(uniqueKeysWithValues: BattleCondition.allCases.map { ($0, false)})
    }
}
