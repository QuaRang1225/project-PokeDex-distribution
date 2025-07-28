//
//  BookMarkFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/28/25.
//

import Foundation
import ComposableArchitecture

/// 북마크 Feature
struct BookMarkFeature: Reducer {
    
    @ObservableState struct State: Equatable {
        
    }
    
    @CasePathable enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
        }
    }
}
