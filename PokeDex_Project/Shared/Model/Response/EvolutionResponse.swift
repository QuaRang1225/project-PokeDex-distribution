//
//  EvolutionResponse.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 5/7/24.
//

import Foundation

struct EvolutionTreeResponse:Codable{
    let status: Int
    let data: EvolutionTo
    let message : String
   
}


