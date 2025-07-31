//
//  DefenseFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/30/25.
//

import Foundation
import ComposableArchitecture

struct DefenseFeature: Reducer {
    
    @ObservableState struct State: Equatable {
        var value: DefenseValue
    }
    
    @CasePathable enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
