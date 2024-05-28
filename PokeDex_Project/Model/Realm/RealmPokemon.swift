//
//  RealmPokemon.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation

struct RealmPokemon:Hashable{
    var id :String
    var num :Int
    var name:String
    var image:String
    var types:[String]
    var stats:[Int]?
}
