//
//  ItemFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/08/23.
//

import Foundation

enum ItemFilter:String,CaseIterable{
    case metal = "metal-coat"
    case tooth = "deep-sea-tooth"
    case scale = "deep-sea-scale"
    case king = "kings-rock"
    case electirizer
    case magmarizer
    case dragon = "dragon-scale"
    case up = "up-grade"
    case claw = "razor-claw"
    case fang = "razor-fang"
    case oval = "oval-stone"
    
    var name:String{
        switch self{
        case .metal:
            return "금속코드"
        case .tooth:
            return "심해의 이빨"
        case .scale:
            return "심해의 비늘"
        case .king:
            return "왕의 징표석"
        case .electirizer:
            return "에레키부스터"
        case .magmarizer:
            return "마그마부스터"
        case .dragon:
            return "용의 비늘"
        case .up:
            return "업그레이드"
        case .claw:
            return "예리한 손톱"
        case .fang:
            return "예리한 이빨"
        case .oval:
            return "동글동글돌"
        }
    }
    
}
