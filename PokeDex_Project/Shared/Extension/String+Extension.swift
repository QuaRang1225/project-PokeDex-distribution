//
//  String+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/19/25.
//

import Foundation
import SwiftUI

extension String {
    static let mosterBallImageURL: String = "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"
    
    var typeColor: Color {
        return Color(self)
    }
}
