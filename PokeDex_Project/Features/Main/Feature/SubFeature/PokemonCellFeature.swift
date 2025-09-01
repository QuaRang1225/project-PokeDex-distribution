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
        var id: Pokemon.ID { pokemon.base?.num ?? 0 }
        var pokemon: Pokemon
    }
    /// 상위에서 접근할 Feature 액션
    @CasePathable enum DelegateAction: Equatable {
        case didTapCell             // 셀 터치 시
    }
    /// 액션 정의
    @CasePathable enum Action: Equatable {
        case delegate(DelegateAction)
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
