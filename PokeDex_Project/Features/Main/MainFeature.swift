//
//  MainFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/17/25.
//

import Foundation
import ComposableArchitecture

/// 메인 Feature
struct MainFeature: Reducer {
    
    struct State: Equatable {
        var pokemons: [PokemonsList] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        
    }
    
}
