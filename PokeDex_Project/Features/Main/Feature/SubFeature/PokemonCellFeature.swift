//
//  PokemonCellFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/19/25.
//

import Foundation
import ComposableArchitecture

/// 포켓몬 리스트 셀 Feature
struct PokemonCellFeature: Reducer {
    
    struct State: Equatable, Identifiable {
        var id: Pokemon.ID { pokemon.id }
        var pokemon: Pokemon
    }
    
    enum Action: Equatable {
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case didTapCell
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate(.didTapCell):
                return .none
            }
        }
    }
}
