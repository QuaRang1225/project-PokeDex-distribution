//
//  CalculatorFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/30/25.
//

import Foundation
import ComposableArchitecture

/// 계산기 Feature
struct CalculatorFeature: Reducer {
    
    @ObservableState struct State: Equatable {
        
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
