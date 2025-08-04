//
//  PokemonItemFilter.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 포켓몬 지닌물건(공격력 상승 아이템)을 나타내는 열거형
enum PokemonItem: String, CaseIterable {
    
    // MARK: - Type-Boosting Items (1.2x)
    case none = "없음"
    case muscleBand = "힘의머리띠"
    case wiseGlasses = "박식안경"
    case silkScarf = "실크스카프"
    case charcoal = "목탄"
    case mysticWater = "신비의물방울"
    case miracleSeed = "기적의씨"
    case magnet = "자석"
    case neverMeltIce = "녹지않는얼음"
    case blackBelt = "검은띠"
    case poisonBarb = "독바늘"
    case softSand = "부드러운모래"
    case sharpBeak = "예리한부리"
    case twistedSpoon = "휘어진스푼"
    case silverPowder = "은빛가루"
    case hardStone = "딱딱한돌"
    case spellTag = "저주의부적"
    case dragonFang = "용의이빨"
    case blackGlasses = "검은안경"
    case metalCoat = "금속코트"
    case fairyFeather = "요정의깃털"

    // MARK: - Special Items
    
    case gem = "주얼"
    case plate = "플레이트"
    case soulDew = "마음의물방울"
    case punchingGlove = "펀치글러브"
    
    // MARK: - Ogerpon Masks
    
    case hearthflameMask = "화덕의가면"
    case cornerstoneMask = "주춧돌의가면"
    case wellspringMask = "우물의가면"
    
    // MARK: - Legendary Orbs
    
    case adamantOrb = "금강옥"
    case lustrousOrb = "백옥"
    case griseousOrb = "백금옥"
    
    // MARK: - Choice Items (1.5x)
    
    case choiceBand = "구애머리띠"
    case choiceSpecs = "구애안경"
    
    // MARK: - Pokémon-Specific Items
    
    case deepSeaTooth = "심해의이빨"
    case lightBall = "전기구슬"
    case thickClub = "굵은뼈"
    
    // MARK: - Other Boosting Items
    
    case boosterEnergy = "부스트에너지"
    case lifeOrb = "생명의구슬"
    case expertBelt = "달인의띠"
    
    // MARK: - Metronome (Sequential Hits)
    
    case metronome1 = "메트로놈 (1회)"
    case metronome2 = "메트로놈 (2회)"
    case metronome3 = "메트로놈 (3회)"
    case metronome4 = "메트로놈 (4회)"
    case metronome5 = "메트로놈 (5회)"
    
    /// 한글 아이템 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
}
