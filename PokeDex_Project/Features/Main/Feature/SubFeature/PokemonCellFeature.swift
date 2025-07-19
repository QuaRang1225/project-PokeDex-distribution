//
//  PokemonCellFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/19/25.
//

import Foundation
import ComposableArchitecture

struct PokemonCellFeature: Reducer {
    
    struct State: Equatable {
        var state: Pokemon? = nil
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
