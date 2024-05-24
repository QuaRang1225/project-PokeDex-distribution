//
//  IndividualFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/23/24.
//

import Foundation

enum IndividualFilter:String,CaseIterable{
    case v
    case u
    case z
    
    var num:Int{
        switch self{
        case .v: 31
        case .u: 30
        case .z: 0
        }
    }
    
}
