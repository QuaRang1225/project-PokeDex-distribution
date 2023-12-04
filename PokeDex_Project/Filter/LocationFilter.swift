//
//  DescriptFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/23.
//

import Foundation

enum LocationFilter:String,CaseIterable{
    
    case national
    case kanto
    case johto
    case hoenn
    case sinnoh
    case unova
    case kalos_ctl
    case kalos_cst
    case kalos_mtn
    case alaola
    case galar
    case paldea
    
    var endPoint:Int{
        switch self{
        case .national:
            return 1
        case .kanto:
            return 2
        case .johto:
            return 7
        case .hoenn:
            return 15
        case .sinnoh:
            return 6
        case .unova:
            return 9
        case .kalos_ctl:
            return 12
        case .kalos_cst:
            return 13
        case .kalos_mtn:
            return   14
        case .alaola:
            return  21
        case .galar:
            return   27
        case .paldea:
            return 31
        }
    }
    var name:String{
        switch self{
        case .national:
            return "전국도감"
        case .kanto:
            return "관동도감"
        case .johto:
            return "성도도감"
        case .hoenn:
            return "호연도감"
        case .sinnoh:
            return "신오도감"
        case .unova:
            return "하나도감"
        case .kalos_ctl:
            return "칼로스 센트럴도감"
        case .kalos_cst:
            return "칼로스 코스트도감"
        case .kalos_mtn:
            return "칼로스 마운틴도감"
        case .alaola:
            return "알로라도감"
        case .galar:
            return "가라르도감"
        case .paldea:
            return "팔데아도감"
        }
    }
    var apiName:String{
        switch self{
        case .national:
            return "national"
        case .kanto:
            return "kanto"
        case .johto:
            return "updated-johto"
        case .hoenn:
            return "updated-hoenn"
        case .sinnoh:
            return "extended-sinnoh"
        case .unova:
            return "updated-unova"
        case .kalos_ctl:
            return "kalos-central"
        case .kalos_cst:
            return "kalos-coastal"
        case .kalos_mtn:
            return "kalos-mountain"
        case .alaola:
            return "updated-alola"
        case .galar:
            return "galar"
        case .paldea:
            return "paldea"
        }
    }
    var region:String{
        switch self{
        case .national,.kanto,.johto,.hoenn,.sinnoh,.unova,.alaola,.galar,.paldea:
            return rawValue
        case .kalos_ctl,.kalos_cst,.kalos_mtn:
            return "kalos"
        }
    }
}
