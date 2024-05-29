//
//  SilverDFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/28/24.
//

import Foundation

enum SilverDFilter:String,CaseIterable{
    case normal = "타입:노말"
    case fighting = "타입:파이팅"
    case flying = "타입:플라잉"
    case poison = "타입:포이즌"
    case ground = "타입:그라운드"
    case rock = "타입:락"
    case bug = "타입:버그"
    case ghost = "타입:고스트"
    case steel = "타입:스틸"
    case fire = "타입:파이어"
    case water = "타입:워터"
    case grass = "타입:그래스"
    case electric = "타입:일렉트릭"
    case psycick = "타입:사이킥"
    case ice = "타입:아이스"
    case dragon = "타입:드래곤"
    case dark = "타입:다크"
    case fariy = "타입:페어리"
    
    var type:String{
        switch self{
        case .normal:return "노말"
        case .fighting:return "격투"
        case .flying:return "비행"
        case .poison:return "독"
        case .ground:return "땅"
        case .rock:return "바위"
        case .bug:return "벌레"
        case .ghost:return "고스트"
        case .steel:return "강철"
        case .fire:return "불꽃"
        case .water:return "물"
        case .grass:return "풀"
        case .electric:return "전기"
        case .psycick:return "에스퍼"
        case .ice:return "얼음"
        case .dragon:return "드래곤"
        case .dark:return "악"
        case .fariy:return "페어리"
        }
    }
}
