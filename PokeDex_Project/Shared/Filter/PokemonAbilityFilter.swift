//
//  PokemonAbilityFilter.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/4/25.
//

import Foundation

/// 포켓몬 특성을 나타내는 열거형
enum PokemonAbility: String, CaseIterable {

    // MARK: - Power Boosting Abilities
    
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
    case mindsEye = "심안"
    case scrappy = "배짱"
    case analytic = "애널라이즈"
    case sheerForce = "우격다짐"
    case stakeout = "잠복"
    case flashFire = "타오르는불꽃"
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
    case swordOfRuin = "재앙의검"
    case beadsOfRuin = "재앙의구슬"
    
    /// 한글 특성 이름을 반환합니다.
    var koreanName: String {
        return self.rawValue
    }
}
