//
//  EvolutionResponse.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation

/// 모든 반환은 같은 형태를 가지고 있어 디코딩용 모델 선언
struct Response<T: Decodable>: Decodable {
    let status: Int                 // 상태코드
    let data: T                     // 데이터
    let message: String             // 메세지
}


