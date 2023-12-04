//
//  EvolutionFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/08/22.
//

import Foundation

enum EvolutionFilter:String,CaseIterable{
    
    case levelUp = "level-up"   //레벨업
    case trade   //통신교환
    case useItem = "use-item"   //사용
    case shed   //파티 슬롯이 비어있을 때
    case spin  //사탕공예를 지닌채로 L버튼 회전
    case dark = "tower-of-darkness"  //악의 탑을 공략해 악의 족자를 보여줌
    case water = "tower-of-waters"    //물의 탑을 공략해 물의 족자를 보여줌
    case critical =  "three-critical-hits"    //한 전투에서 3번의 급소를 맞춤
    case damage =  "take-damage"    //기절하지 않고 49 이상의 누적 데미지를 입은 후 모래먼지구덩이의 고인돌 아래를 지나감
    case other
    case agile = "agile-style-move"   //배리어러시 속공으로 20번 사용
    case strong = "strong-style-move"  //독침천발을 강공으로 20번 사용
    case redeil =  "recoil-damage"  //누적 반동 데미지 294 이상 입은 상태에서 레벨업
    
    var description:String{
        switch self{
        case .levelUp:
            return "레벨업"
        case .trade:
            return "통신교환"
        case .useItem:
            return "사용"
        case .shed:
            return "파티 슬롯이 비어있을 때"
        case .spin:
            return "사탕공예를 지닌채로 L버튼 회전"
        case .dark:
            return "악의 탑을 공략해 악의 족자를 보여줌"
        case .water:
            return "물의 탑을 공략해 물의 족자를 보여줌"
        case .critical:
            return "한 전투에서 3번의 급소를 맞춤"
        case .damage:
            return "기절하지 않고 49 이상의 누적 데미지를 입은 후 모래먼지구덩이의 고인돌 아래를 지나감"
        case .other:
            return ""
        case .agile:
            return "배리어러시 속공으로 20번 사용"
        case .strong:
            return "독침천발을 강공으로 20번 사용"
        case .redeil:
            return "누적 반동 데미지 294 이상 입은 상태에서 레벨업"
        }
    }
    
}

