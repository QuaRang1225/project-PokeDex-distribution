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
    /// 공격/방어 모드
    enum Mode {
        case power
        case defense
    }
    
    @ObservableState struct State: Equatable {
        var pokemonInfo: PokemonInfo
        var mode: Mode = .power
        
        var powerState: PowerFeature.State? = nil
        var defenseState: DefenseFeature.State? = nil
    }
    /// 사용자 액션
    @CasePathable enum ViewAction: Equatable {
        case viewDidLoad                        // 뷰 생성 시
        case selectedMode(_ mode: Mode)         // 모드 선택 시
    }
    /// 하위뷰 사용자 액션
    @CasePathable enum ChildViewAction: Equatable {
        
    }
    /// 내부 액션
    @CasePathable enum InsideAction: Equatable {
        
    }
    /// 상위에서 접근할 Feature 액션
    @CasePathable enum DelegateAction: Equatable {
        case didTappedDismissButton             // 닫기 버튼 선택 시
    }
    /// 하위 Feature 액션
    @CasePathable enum ChildAction: Equatable {
        case powerAction(_ action: PowerFeature.Action)
        case defenseAction(_ action: DefenseFeature.Action)
    }
    /// 셀 액션
    @CasePathable enum CellAction: Equatable {
        
    }
    /// 액션 정의
    @CasePathable enum Action: Equatable {
        case view(ViewAction)
        case childView(ChildViewAction)
        case inside(InsideAction)
        case delegate(DelegateAction)
        case child(ChildAction)
        case cell(CellAction)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .viewDidLoad:
                    return initializeValue(&state)
                case let .selectedMode(mode):
                    return changedMode(&state, mode: mode)
                }
            default:
                return .none
            }
        }
        .ifLet(\.powerState, action: \.child.powerAction) {
            PowerFeature()
        }
        .ifLet( \.defenseState, action: \.child.defenseAction) {
            DefenseFeature()
        }
    }
    private func initializeValue(_ state: inout State) -> Effect<Action> {
        state.powerState = PowerFeature.State(
            pokemonState: PokemonAttckState(
                type: state.pokemonInfo.types,
                name: state.pokemonInfo.name,
                pysical: state.pokemonInfo.stats[1],
                special: state.pokemonInfo.stats[3]
            )
        )
        state.defenseState = DefenseFeature.State(
            pokemonState: PokemonDefenseState(
                type: state.pokemonInfo.types,
                name: state.pokemonInfo.name,
                hp: state.pokemonInfo.stats[0],
                pysical: state.pokemonInfo.stats[2],
                special: state.pokemonInfo.stats[4]
            )
        )
        return .none
    }
    /// 모드 변경
    private func changedMode(_ state: inout State, mode: Mode) -> Effect<Action> {
        state.mode = mode
        return .none
    }
}
