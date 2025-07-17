//
//  VarietiesResponse.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/3/24.
//

import Foundation

struct VarietiesRespons:Codable{
    let status: Int
    let data: Varieties
    let message : String
}
