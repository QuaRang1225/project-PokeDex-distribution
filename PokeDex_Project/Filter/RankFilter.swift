//
//  RankFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/23/24.
//

import Foundation

enum RankFilter:Double,CaseIterable{
    case hsix = 0.25
    case hfive = 0.285714
    case hfour = 0.333333
    case hthree = 0.4
    case htwo = 0.5
    case hone = 0.666667
    case none = 1
    case one = 1.5
    case two = 2
    case three = 2.5
    case four = 3
    case five = 3.5
    case six = 4
    
    var name:String{
        switch self{
        
        case .hsix:
            return "-6 랭크"
        case .hfive:
            return "-5 랭크"
        case .hfour:
            return "-4 랭크"
        case .hthree:
            return "-3 랭크"
        case .htwo:
            return "-2 랭크"
        case .hone:
            return "-1 랭크"
        case .none:
            return "보통"
        case .one:
            return "+1 랭크"
        case .two:
            return "+2 랭크"
        case .three:
            return "+3 랭크"
        case .four:
            return "+4 랭크"
        case .five:
            return "+5 랭크"
        case .six:
            return "+6 랭크"
        }
    }
}
enum CharacterFilter:String,CaseIterable{
    case none
    case up
    case down
    
    var name:String{
        switch self{
        case .none:
            return "무보정 (1배)"
        case .up:
            return "상승 (1.1배)"
        case .down:
            return "하강 (0.9배)"
        }
    }
    var value:Double{
        switch self{
        case .none:
            return 1
        case .up:
            return 1.1
        case .down:
            return 0.9
        }
    }
}
