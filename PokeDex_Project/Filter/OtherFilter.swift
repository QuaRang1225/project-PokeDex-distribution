//
//  OtherFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/08/23.
//

import Foundation

enum OtherFiler:String,CaseIterable{
    case pawmot
    case maushold
    case brambleghast
    case rabsca
    case palafin
    case annihilape
    case kingambit
    case gholdengo
    
    var evol:String{
        switch self{
        case .pawmot:
            return "레츠고 모드에서 1,000보 이상 걷고 볼로 돌아가지 않은 상태에서 레벨 업"
        case .maushold:
            return "레벨 25 이상일 때 랜덤으로 진화"
        case .brambleghast:
            return "레츠고 모드에서 1,000보 이상 걷고 레벨 업"
        case .rabsca:
            return "레츠고 모드에서 1,000보 이상 걷고 레벨 업"
        case .palafin:
            return "38레벨 이상 다른 플레이어와 유니온 서클을 플레이하고 있는 상태에서 레벨업"
        case .annihilape:
            return "분노의주먹을 20번 사용후 레벨업"
        case .kingambit:
            return "대장의징표를 지닌 절각참을 3마리 쓰러뜨린 후 레벨업"
        case .gholdengo:
            return "모으령의코인을 999개 획득 후 레벨업"
        }
    }
}
