//
//  PokemonAbilityFilter.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 포켓몬 특성을 나타내는 열거형
enum AbilityCondition: String, CaseIterable, LosslessStringConvertible {

    // MARK: - Power Boosting Abilities
    case none = "없음"
    case reckless = "이판사판"
    case ironFist = "철주먹"
    case technician = "테크니션"
    case purePower = "순수한힘"
    case hugePower = "천하장사"
    case steelworker = "강철술사"
    case steelySpirit = "강철정신"
    case toughClaws = "단단한발톱"
    case toxicBoost = "독폭주"
    case flareBoost = "열폭주"
    case sandForce = "모래의힘"
    case rockyPayload = "바위나르기"
    case waterBubble = "수포"
    case sharpness = "예리함"
    case strongJaw = "옹골찬턱"
    case dragonsMaw = "용의턱"
    case transistor = "트랜지스터"
    case punkRock = "펑크록"
    case megaLauncher = "메가런처"
    case guts = "근성"
    case hustle = "의욕"
    case solarPower = "선파워"
    case adaptability = "적응력"
    case neuroforce = "브레인포스"

    // MARK: - Type-Pinch Abilities (HP < 1/3)
    
    case blaze = "맹화"
    case torrent = "급류"
    case overgrow = "심록"
    case swarm = "벌레의알림"

    // MARK: - Skin Abilities
    
    case normalize = "노말스킨"
    case aerilate = "스카이스킨"
    case galvanize = "일렉트릭스킨"
    case refrigerate = "프리즈스킨"
    case pixilate = "페어리스킨"

    // MARK: - Conditional/Situational Abilities
    
    case electromorphosis = "전기로바꾸기"
    case windPower = "풍력발전"
    case rivalrySameGender = "투쟁심(성별같음)"
    case rivalryDifferentGender = "투쟁심(성별다름)"
    case analytic = "애널라이즈"
    case sheerForce = "우격다짐"
    case stakeout = "잠복"
    case parentalBond = "부자유친"
    case supremeOverlord1 = "총대장 (1마리 기절)"
    case supremeOverlord2 = "총대장 (2마리 기절)"
    case supremeOverlord3 = "총대장 (3마리 기절)"
    case supremeOverlord4 = "총대장 (4마리 기절)"
    case supremeOverlord5 = "총대장 (5마리 기절)"
    case plus = "플러스"
    case minus = "마이너스"
    case sniper = "스나이퍼"
    case tintedLens = "색안경"

    // MARK: - Stat-Lowering/Hindering Abilities
    
    case slowStart = "슬로스타트"
    case defeatist = "무기력"
    
    // MARK: - Paradox/Legendary Abilities
    
    case gorillaTactics = "무아지경"
    case protosynthesis = "고대활성"
    case quarkDrive = "쿼크차지"
    case orichalcumPulse = "진홍빛고동"
    case hadronEngine = "하드론엔진"
    
    var description: String {
        self.rawValue
    }
    
    /// 한글 특성 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
    
    /// 포켓몬 상태 계산
    func calculate(state: inout PokemonAttckState) -> PokemonAttckState {
        switch self {
        case .none:
            return state
        case .reckless:
            if let recoid = state.battleModifier[.recoid], recoid {
                state.result *= 1.2
            }
            // 반동기술일 경우만 1.2배 증가
            return state
        case .ironFist:
            if let punch = state.battleModifier[.punch], punch {
                state.result *= 1.2
            }
            // 펀치기술일 경우만 1.2배 증가
            return state
        case .technician:
            if state.power <= 60 {
                state.result *= 1.5
            }
            // 위력 60 이하의 기술 1.5배 증가
            return state
        case .purePower:
            if state.attackedMode == .physical {
                state.result *= 2
            }
            // 물리 공격 2배
            return state
        case .hugePower:
            if state.attackedMode == .physical {
                state.result *= 2
            }
            // 물리 공격 2배
            return state
        case .steelworker:
            if state.type == .steel {
                state.result *= 1.5
            }
            // 강철타입 기술 1.5배
            return state
        case .steelySpirit:
            if state.type == .steel {
                state.result *= 1.5
            }
            // 강철타입 기술 1.5배
            return state
        case .toughClaws:
            if let contact = state.battleModifier[.contact], contact {
                state.result *= 1.3
            }
            // 접촉기술 1.3배
            return state
        case .toxicBoost:
            if state.status == .poison {
                state.result *= 1.5
            }
            // 독 상태에 1.5배
            return state
        case .flareBoost:
            if state.status == .burn, state.attackedMode == .special {
                state.result *= 1.5
            }
            // 화상의 경우 특수공격 1.5배
            return state
        case .sandForce:
            if state.weather == .sandstorm,
               [
                TypeFilter.ground.rawValue,
                TypeFilter.rock.rawValue,
                TypeFilter.steel.rawValue
               ].contains(state.type.rawValue) {
                state.result *= 1.3
            }
            // 모래바람 상태에서, 땅/바위/강철 위력 1.3배
            return state
        case .rockyPayload:
            if state.type == .rock {
                state.result *= 1.5
            }
            // 바위타입 기술 위력 1.5배
            return state
        case .waterBubble:
            if state.type == .water {
                state.result *= 2
            }
            // 물타입 기술 위력 2배
            return state
        case .sharpness:
            if let cutting = state.battleModifier[.cutting], cutting {
                state.result *= 1.5
            }
            // 베기 기술 1.5배
            return state
        case .strongJaw:
            if let bitting = state.battleModifier[.bitting], bitting {
                state.result *= 1.5
            }
            // 물기 기술 1.5배
            return state
        case .dragonsMaw:
            if state.type == .dragon {
                state.result *= 1.5
            }
            // 드래곤 기술 1.5배
            return state
        case .transistor:
            if state.type == .electric {
                state.result *= 1.5
            }
            // 전기 기술 1.5배
            return state
        case .punkRock:
            if let sounding = state.battleModifier[.sounding], sounding {
                state.result *= 1.3
            }
            // 소리 기술 1.3배
            return state
        case .megaLauncher:
            if let wave = state.battleModifier[.wave], wave {
                state.result *= 1.5
            }
            // 파동 기술 1.5배
            return state
        case .guts:
            if state.attackedMode == .physical {
                if state.status == .burn {
                    state.result *= 3
                } else if state.status != .none {
                    state.result *= 1.5
                }
            }
            // 화상의 경우 특수공격 1.5배
            // 상태이상 시 공격 1.5배
            // 화상의 절반 효과 받지 않음
            return state
        case .hustle:
            if state.attackedMode == .physical {
                state.result *= 1.5
            }
            // 공격 1.5배
            return state
        case .solarPower:
            if state.weather == .sunny, state.attackedMode == .special {
                state.result *= 1.5
            }
            // 쾌청 시 특수공격 1.5배
            return state
        case .adaptability:
            if state.types.contains(state.type.rawValue) {
                state.result *= (4/3)
            }
            // 자속보정이 2배 들어감
            return state
        case .neuroforce:
            if state.compatibility == .double ||
                state.compatibility == .quadruple {
                state.result *= 1.2
            }
            // 효과가 뛰어날 경우 1.2배 증가
            return state
        case .blaze:
            if state.type == .fire {
                state.result *= 1.5
            }
            // 불꽃 1.5배
            return state
        case .torrent:
            if state.type == .water {
                state.result *= 1.5
            }
            // 물 1.5배
            return state
        case .overgrow:
            if state.type == .grass {
                state.result *= 1.5
            }
            // 풀 1.5배
            return state
        case .swarm:
            if state.type == .bug {
                state.result *= 1.5
            }
            // 벌레 1.5배
            return state
        case .normalize:
            if state.type != .normal {
                state.result *= 1.5
            }
            state.result *= 1.2
            // 모든 타입 1.5배 + 1.2배 추가
            return state
        case .aerilate:
            if state.type == .normal {
                state.result *= 1.5
            }
            if state.type == .normal || state.type == .flying {
                state.result *= 1.2
            }
            // 노말 타입 -> 비행 1.5배 + 1.2배 추가
            return state
        case .galvanize:
            if state.type == .normal {
                state.result *= 1.5
            }
            if state.type == .normal || state.type == .electric {
                state.result *= 1.2
            }
            // 노말 타입 -> 전기 1.5배 + 1.2배 추가
            return state
        case .refrigerate:
            if state.type == .normal {
                state.result *= 1.5
            }
            if state.type == .normal || state.type == .ice {
                state.result *= 1.2
            }
            // 노말 타입 -> 얼음 1.5배 + 1.2배 추가
            return state
        case .pixilate:
            if state.type == .normal {
                state.result *= 1.5
            }
            if state.type == .normal || state.type == .fairy {
                state.result *= 1.2
            }
            // 노말 타입 -> 페어리 1.5배 + 1.2배 추가
            return state
        case .electromorphosis:
            if state.type == .electric {
                state.result *= 2.0
            }
            // 전기타입 2배
            return state
        case .windPower:
            if state.type == .electric {
                state.result *= 2.0
            }
            // 전기타입 2배
            return state
        case .rivalrySameGender:
            state.result *= 1.25
            // 기술 위력 1.25배
            return state
        case .rivalryDifferentGender:
            state.result *= 0.75
            // 기술 위력 0.75배
            return state
        case .analytic:
            state.result *= 1.3
            // 기술 위력 1.3배
            return state
        case .sheerForce:
            if let sideEffect = state.battleModifier[.sideEffect], sideEffect {
                state.result *= 1.3
            }
            // 추가효과 기술 1.3배
            return state
        case .stakeout:
            if let change = state.battleModifier[.change], change {
                state.result *= 1.3
            }
            // 교체/난입한 상대에게 2배
            return state
        case .parentalBond:
            if state.attackedMode == .physical {
                state.result *= 1.25
            }
            // 공격기술 1.25배
            return state
        case .supremeOverlord1:
            state.result *= 1.1
            // 공,특공 1.1배
            return state
        case .supremeOverlord2:
            state.result *= 1.2
            // 공,특공 1.2배
            return state
        case .supremeOverlord3:
            state.result *= 1.3
            // 공,특공 1.3배
            return state
        case .supremeOverlord4:
            state.result *= 1.4
            // 공,특공 1.4배
            return state
        case .supremeOverlord5:
            state.result *= 1.5
            // 공,특공 1.5배
            return state
        case .plus:
            if let withMinus = state.battleModifier[.withMinus], withMinus, state.attackedMode == .special {
                state.result *= 1.5
            }
            // 마이너스와 함께 있으면 특공 1.5배 상승
            return state
        case .minus:
            if let withPlus = state.battleModifier[.withPlus], withPlus, state.attackedMode == .special {
                state.result *= 1.5
            }
            // 플러스와 함꼐 있으면 특공 1.5배 상승
            return state
        case .sniper:
            if let criticalHit = state.battleModifier[.criticalHit], criticalHit {
                state.result *= 1.5
            }
            // 급소 시 2.25배 증가
            return state
        case .tintedLens:
            if state.compatibility == .half || state.compatibility == .halfOfhalf {
                state.result *= 2
            }
            // 반감기는 2배가 됨 (0.5 -> 1, 0.25 -> 0.5)
            return state
        case .slowStart:
            if state.ability == .slowStart, state.attackedMode == .physical {
                state.result *= 0.5
            }
            // 슬로스타트 공격력 0.5배
            return state
        case .defeatist:
            state.result *= 0.5
            // 공/특공 0.5배
            return state
        case .gorillaTactics:
            if state.attackedMode == .physical {
                state.result *= 1.5
            }
            // 공격 1.5배
            return state
        case .protosynthesis:
            if state.item == .boosterEnergy || state.weather == .sunny {
                state.result *= 1.3
            }
            // 부스트에너지를 지니고 있거나, 쾌청일 때 가장 높은 능력치 1.3배 증가
            return state
        case .quarkDrive:
            if state.item == .boosterEnergy || state.field == .electric {
                state.result *= 1.3
            }
            // 부스트에너지를 지니고 있거나, 일렉트릭 필드일 때 가장 높은 능력치 1.3배 증가
            return state
        case .orichalcumPulse:
            if state.attackedMode == .physical {
                state.result *= 1.5
            }
            // 공격 1.5배
            return state
        case .hadronEngine:
            if state.attackedMode == .special {
                state.result *= 1.5
            }
            // 특공 1.5배
            return state
        }
    }
    
    // 문자열 → 타입으로 변환
    init?(_ description: String) {
        self.init(rawValue: description)
    }
}
