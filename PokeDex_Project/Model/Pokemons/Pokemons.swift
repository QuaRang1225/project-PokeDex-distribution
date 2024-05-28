//
//  Pokemon.swift
//  PokeDex_Developer
//
//  Created by 유영웅 on 4/30/24.
//

import Foundation


struct Pokemons:Codable{
    var id : Int
    var color : String
    var base : Base
    var captureRate : Int
    var dex : [Dex]
    var eggGroup : [String]
    var evolutionTree : Int
    var formsSwitchable : Bool
    var genderRate : Int
    var genra : String
    var hatchCounter : Int
    var name : String
    var textEntries : TextEntries
    var varieties : [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case color = "color"
        case base = "base"
        case captureRate = "capture_rate"
        case dex = "dex"
        case eggGroup = "egg_group"
        case evolutionTree = "evolution_tree"
        case formsSwitchable = "forms_switchable"
        case genderRate = "gender_rate"
        case genra = "genra"
        case hatchCounter = "hatch_counter"
        case name = "name"
        case textEntries = "text_entries"
        case varieties = "varieties"
    }
}

