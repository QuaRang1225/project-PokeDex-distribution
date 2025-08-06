//
//  MyPokemon.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation
import RealmSwift

/// RealmDB에 직접적으로 저장되는 Object
class RealmObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId   // ID
    @Persisted var num: Int                         // 도감 번호
    @Persisted var name: String                     // 이름
    @Persisted var image: String                    // 이미지
    @Persisted var types: List<String>              // 타입
}
