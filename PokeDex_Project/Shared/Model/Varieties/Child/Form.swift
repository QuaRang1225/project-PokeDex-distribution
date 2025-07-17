//
//  Form.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation

/// 폼 정보
struct Form: Codable,Hashable {
    var id:[Double]             // ID
    var images: [String]        // 폼 이미지
    var name: [String]          // 폼 이름
}
