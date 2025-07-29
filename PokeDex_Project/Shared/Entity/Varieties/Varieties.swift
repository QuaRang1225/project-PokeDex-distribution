//
//  Varieties.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation

/// 다른모습
struct Varieties: Codable, Hashable, Equatable {
    var id: String                  // ID
    var abilites: Abilites          // 특성 (숨특 여부, 특성명, 특성 설명)
    var form: Form                  // 폼 (ID, 폼 이미지, 이름)
    var height: Double              // 키
    var stats: [Int]                // 스탯
    var types: [String]             // 타입
    var weight: Double              // 무게

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case abilites, form, height, stats, types, weight
    }
}


// MARK: - 내부 메서드
extension Varieties {
    /// 리전 폼 형식대로 변환
    func makeVariety() -> [Self] {
        let zip1 = zip(form.id, form.name)
        let zip2 = zip(zip1, form.images).map { ($0.0, $0.1, $1) }
        return zip2
            .map { id, name, image in
                var currentTypes: [String]
                
                if let types = TypeFilter(pokemonNumber: id, rawValue: name)?.rawValue {
                    currentTypes = [types]
                } else {
                    currentTypes = self.types
                }
               
                return Varieties(
                    id: name,
                    abilites: abilites,
                    form: Form(id: [id], images: [image], name: [name]),
                    height: height,
                    stats: stats,
                    types: currentTypes,
                    weight: weight
                    )
            }
    }
}
