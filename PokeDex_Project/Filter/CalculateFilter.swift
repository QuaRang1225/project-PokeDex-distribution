//
//  CalculateFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/23/24.
//

import Foundation

enum CalculateFilter:CaseIterable{
    case attack
    case defense
    
    var name:String{
        switch self{
        case .attack:
            return "결정력"
        case .defense:
            return "내구력"
        }
    }
}
