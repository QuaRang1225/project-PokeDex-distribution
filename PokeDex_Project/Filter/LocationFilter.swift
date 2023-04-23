//
//  DescriptFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/23.
//

import Foundation

enum LocationFilter:CaseIterable{
    
    case x
    case y
    case OR
    case AS
    case letsgoPikachu
    case letsgoEevee
    case sword
    case shield
    
    var endPoint:Int{
        switch self{
        case .x:
            return 23
        case .y:
            return 31
        case .OR:
            return 39
        case .AS:
            return 47
        case .letsgoPikachu:
            return 55
        case .letsgoEevee:
            return 65
        case .sword:
            return 75
        case .shield:
            return 85
        }
    }
    var name:String{
        switch self{
        case .x:
            return "X"
        case .y:
            return "Y"
        case .OR:
            return "오메가 루비"
        case .AS:
            return "알파 사파이어"
        case .letsgoPikachu:
            return "레츠고 피카츄"
        case .letsgoEevee:
            return "레츠고 이브이"
        case .sword:
            return "소드"
        case .shield:
            return "실드"
        }
    }
}
