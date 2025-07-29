//
//  RegionFilter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/15/24.
//

import Foundation

/// 지역을 선택하기 위한 필터
enum RegionFilter: String, CaseIterable {
    case national = "전국"
    case kanto = "관동"
    case originalJohto = "성도(구)"
    case hoenn = "호연(구)"
    case originalSinnoh = "신오(구)"
    case extendedSinnoh = "신오(신)"
    case updatedJohto = "성도(신)"
    case originalUnova = "하나(구)"
    case updatedUnova = "하나(신)"
    case conquestGallery = "컨퀘스트"
    case kalosCentral = "칼로스 센트럴"
    case kalosCoastal = "칼로스 코스트"
    case kalosMountain = "칼로스 마운틴"
    case updatedHoenn = "호연(신)"
    case originalAlola = "알로라(구)"
    case originalMelemele = "멜레멜레 삼(구)"
    case originalAkala = "아칼라 섬(구)"
    case originalUlaula = "울라울라 섬(구)"
    case originalPoni = "포니 섬(구)"
    case updatedAlola = "알로라(신)"
    case updatedMelemele = "멜레멜레 섬(신)"
    case updatedAkala = "아칼라 섬(신)"
    case updatedUlaula = "울라울라 섬(신)"
    case updatedPoni = "포니 섬(신)"
    case letsgoKanto = "레츠고"
    case galar = "가라르"
    case isleOfArmor = "갑옷의 외딴섬"
    case crownTundra = "왕관의 설원"
    case hisui = "히스이"
    case paldea = "팔데아"
    case kitakami = "북신의 고장"
    case blueberry = "블루베리 아카데미"
}
