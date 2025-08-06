//
//  PokemonItemFilter.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 포켓몬 지닌물건(공격력 상승 아이템)을 나타내는 열거형
enum ItemCondition: String, CaseIterable, LosslessStringConvertible {
    
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
    
    var description: String {
        self.rawValue
    }
    
    /// 한글 아이템 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
    
    /// 포켓몬 상태 계산
    func calculate(state: inout PokemonState) -> PokemonState {
        switch self {
        case .none:
            return state
        case .muscleBand:
            if state.attackedMode == .physical {
                state.result *= 1.1
            }
            // 물리공격 1.1배
            return state
        case .wiseGlasses:
            if state.attackedMode == .special {
                state.result *= 1.1
            }
            // 특수공격 1.1배
            return state
        case .silkScarf:
            if state.type == .normal {
                state.result *= 1.2
            }
            // 노말 1.2배
            return state
        case .charcoal:
            if state.type == .fire {
                state.result *= 1.2
            }
            // 불꽃 1.2배
            return state
        case .mysticWater:
            if state.type == .water {
                state.result *= 1.2
            }
            // 물 1.2배
            return state
        case .miracleSeed:
            if state.type == .grass {
                state.result *= 1.2
            }
            // 풀 1.2배
            return state
        case .magnet:
            if state.type == .electric {
                state.result *= 1.2
            }
            // 전기 1.2배
            return state
        case .neverMeltIce:
            if state.type == .ice {
                state.result *= 1.2
            }
            // 얼음 1.2배
            return state
        case .blackBelt:
            if state.type == .fighting {
                state.result *= 1.2
            }
            // 격투 1.2배
            return state
        case .poisonBarb:
            if state.type == .poison {
                state.result *= 1.2
            }
            // 독 1.2배
            return state
        case .softSand:
            if state.type == .ground {
                state.result *= 1.2
            }
            // 땅 1.2배
            return state
        case .sharpBeak:
            if state.type == .flying {
                state.result *= 1.2
            }
            // 비행 1.2배
            return state
        case .twistedSpoon:
            if state.type == .psychic {
                state.result *= 1.2
            }
            // 에스파 1.2배
            return state
        case .silverPowder:
            if state.type == .bug {
                state.result *= 1.2
            }
            // 벌레 1.2배
            return state
        case .hardStone:
            if state.type == .rock {
                state.result *= 1.2
            }
            // 바위 1.2배
            return state
        case .spellTag:
            if state.type == .ghost {
                state.result *= 1.2
            }
            // 고스트 1.2배
            return state
        case .dragonFang:
            if state.type == .dragon {
                state.result *= 1.2
            }
            // 드래곤 1.2배
            return state
        case .blackGlasses:
            if state.type == .dark {
                state.result *= 1.2
            }
            // 악 1.2배
            return state
        case .metalCoat:
            if state.type == .steel {
                state.result *= 1.2
            }
            // 강철 1.2배
            return state
        case .fairyFeather:
            if state.type == .fairy {
                state.result *= 1.2
            }
            // 페어리 1.2배
            return state
        case .gem:
            state.result *= 1.3
            // 1.3배
            return state
        case .plate:
            state.result *= 1.2
            // 1.2배
            return state
        case .soulDew:
            if (state.name.contains("라티오스") || state.name.contains("라티아스")),
               (state.type == .psychic || state.type == .dragon) {
                state.result *= 1.2
            }
            // 라티오스/라티아스 에스퍼/드래곤 기술 1.2배
            return state
        case .punchingGlove:
            if let punch = state.battleModifier[.punch], punch {
                state.result *= 1.1
            }
            // 펀치기술 1.1배
            return state
        case .adamantOrb:
            if state.name.contains("디아루가"),
               (state.type == .steel || state.type == .dragon) {
                state.result *= 1.2
            }
            // 디아루가 강철/드래곤 기술 1.2배
            return state
        case .lustrousOrb:
            if state.name.contains("펄기아"),
               (state.type == .water || state.type == .dragon) {
                state.result *= 1.2
            }
            // 펄기아 물/드래곤 기술 1.2배
            return state
        case .griseousOrb:
            if state.name.contains("기라티나"),
               (state.type == .ghost || state.type == .dragon) {
                state.result *= 1.2
            }
            // 기타리나 고스트/드래곤 1.2배
            return state
        case .choiceBand:
            if state.attackedMode == .physical {
                state.result *= 1.5
            }
            // 공격 1.5배
            return state
        case .choiceSpecs:
            if state.attackedMode == .special {
                state.result *= 1.5
            }
            // 특공 1.5배
            return state
        case .deepSeaTooth:
            if state.name.contains("진주몽"),
                state.attackedMode == .special {
                state.result *= 2
            }
            // 진주몽 특공 2배
            return state
        case .lightBall:
            if state.name.contains("피카츄") {
                state.result *= 2
            }
            // 피카츄 공/특공 2배
            return state
        case .thickClub:
            if state.name.contains("텅구리") ||
                state.name.contains("탕구리") {
                state.result *= 2
            }
            // 탕구리/텅구리 공격 2배
            return state
        case .boosterEnergy:
            // 고대활성/쿼크차지 가장 높은 능력치 1.5배
            return state
        case .lifeOrb:
            state.result *= 1.3
            // 위력 1.3배
            return state
        case .expertBelt:
            if state.compatibility == .double || state.compatibility == .quadruple {
                state.result *= 1.2
            }
            // 효과가 굉장한 기술 1.2배
            return state
        case .metronome1:
            state.result *= 1.2
            // 위력 1.2배
            return state
        case .metronome2:
            state.result *= 1.4
            // 위력 1.4배
            return state
        case .metronome3:
            state.result *= 1.6
            // 위력 1.6배
            return state
        case .metronome4:
            state.result *= 1.8
            // 위력 1.8배
            return state
        case .metronome5:
            state.result *= 2
            // 위력 2.0배
            return state
        }
    }
    
    // 문자열 → 타입으로 변환
    init?(_ description: String) {
        self.init(rawValue: description)
    }
}
