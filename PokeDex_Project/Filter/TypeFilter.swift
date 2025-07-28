//
//  TypeFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import Foundation

enum TypeFilter: String, CaseIterable {
    case bug = "벌레"
    case normal = "노말"
    case fairy = "페어리"
    case dark = "악"
    case flying = "비행"
    case dragon = "드래곤"
    case electric = "전기"
    case fighting = "격투"
    case fire = "불꽃"
    case ghost = "고스트"
    case grass = "풀"
    case ground = "땅"
    case ice = "얼음"
    case poison = "독"
    case psychic = "에스퍼"
    case rock = "바위"
    case steel = "강철"
    case water = "물"
//    case unknown = "???"
}

// MARK: - 실버디
extension TypeFilter {
    init?(pokemonNumber: Int, rawValue: String) {
        switch pokemonNumber {
        case 493:
            if let type = TypeFilter(rawValue: rawValue) {
                self = type
            } else {
                return nil
            }
        case 773:
            switch rawValue {
            case "타입:노말": self = .normal
            case "타입:파이팅": self = .fighting
            case "타입:플라잉": self = .flying
            case "타입:포이즌": self = .poison
            case "타입:그라운드": self = .ground
            case "타입:락": self = .rock
            case "타입:버그": self = .bug
            case "타입:고스트": self = .ghost
            case "타입:스틸": self = .steel
            case "타입:파이어": self = .fire
            case "타입:워터": self = .water
            case "타입:그래스": self = .grass
            case "타입:일렉트릭": self = .electric
            case "타입:사이킥": self = .psychic
            case "타입:아이스": self = .ice
            case "타입:드래곤": self = .dragon
            case "타입:다크": self = .dark
            case "타입:페어리": self = .fairy
            default: return nil
            }
        default: return nil
        }
    }
}
