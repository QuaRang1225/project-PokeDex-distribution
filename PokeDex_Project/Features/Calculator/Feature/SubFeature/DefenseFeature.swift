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
        var level: String = "\(1)"                      // 레벨
        var hp_efforts: String = "\(252)"               // 노력치
        var hp_object: String = "\(31)"                 // 개체값
        var defense_efforts: String = "\(252)"          // 노력치
        var defense_object: String = "\(31)"            // 개체값
        var personality: Double = 1.0                   // 성격
        var defenseMode: AttackCondition = .physical    // 방어/특방
        var rankUp: String = "0"                        // 랭크업
        var pokemonState: PokemonDefenseState           // 방어 상태
        
        /// 체력 실수치
        var hp_real: Int {
            DefenseFeature.calculateHPStat(state: self)
        }
        /// 방어 실수치
        var defense_real: Int {
            DefenseFeature.calculateDefenseStat(state: self)
        }
        /// 내구력 
        var defense: Int {
            Int(Double(hp_real * defense_real) / 0.411)
        }
    }
    /// 사용자 액션
    @CasePathable enum ViewAction: Equatable {
        case inputtedLevel(_ level: String)                                         // 레벨 선택
        case changedRankUp(_ rankUp: String)                                        // 랭크업 선택
        case changedHPEfforts(_ efforts: String)                                    // 체력 노력치 선택
        case changedHPObjects(_ object: String)                                     // 체력 개체값 선택
        case changedDefenseEfforts(_ efforts: String)                               // 체력 노력치 선택
        case changedDefenseObjects(_ object: String)                                // 체력 개체값 선택
        case changedPersonality(_ personality: Double)                              // 성격 선택
        case selectedDefense(_ defense: AttackCondition)                            // 물리/특수 선택
    }
    /// 액션 정의
    @CasePathable enum Action: Equatable {
        case view(ViewAction)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case let .inputtedLevel(level):
                    return updateLevel(&state, level: level)
                case let .changedRankUp(rankUp):
                    return updateRankUp(&state, rankUp: rankUp)
                case let .changedHPEfforts(hp_effort):
                    return updateHPEffort(&state, effort: hp_effort)
                case let .changedHPObjects(hp_object):
                    return updateHPObject(&state, object: hp_object)
                case let.changedDefenseEfforts(defense_effort):
                    return updateDefenseEffort(&state, effort: defense_effort)
                case let .changedDefenseObjects(defense_object):
                    return updateDefenseObject(&state, object: defense_object)
                case let .changedPersonality(personality):
                    return updatePersonality(&state, personality: personality)
                case let .selectedDefense(defense):
                    return updateDefense(&state, defense: defense)
                }
            }
        }
    }
    /// 방어/특방 업데이트
    private func updateDefense(_ state: inout State, defense: AttackCondition) -> Effect<Action> {
        state.defenseMode = defense
        return .none
    }
    /// 레벨 업데이트
    private func updateLevel(_ state: inout State, level: String) -> Effect<Action> {
        guard let level = level.extractNumber,
              (1...100) ~= level else {
            state.level = "1"
            return .none
        }
        state.level = "\(level)"
        return .none
    }
    /// 체력 노력치 업데이트
    private func updateHPEffort(_ state: inout State, effort: String) -> Effect<Action> {
        state.hp_efforts = effort
        return .none
    }
    /// 방어 노력치 업데이트
    private func updateDefenseEffort(_ state: inout State, effort: String) -> Effect<Action> {
        state.defense_efforts = effort
        return .none
    }
    /// 체력 개체값 업데이트
    private func updateHPObject(_ state: inout State, object: String) -> Effect<Action> {
        state.hp_object = object
        return .none
    }
    /// 방어 개체값 업데이트
    private func updateDefenseObject(_ state: inout State, object: String) -> Effect<Action> {
        state.defense_object = object
        return .none
    }
    /// 랭크업 업데이트
    private func updateRankUp(_ state: inout State, rankUp: String) -> Effect<Action> {
        state.rankUp = rankUp
        return .none
    }
    /// 성격 업데이트
    private func updatePersonality(_ state: inout State, personality: Double) -> Effect<Action> {
        state.personality = personality
        return .none
    }
}

extension DefenseFeature {
    /// 체력 실수치 계산
    static func calculateHPStat(state: DefenseFeature.State) -> Int {
        let hp = Double(state.pokemonState.hp)                      // 능력치
        let iv = Double(state.hp_object) ?? 0                       // 개체값
        let ev = Double(state.hp_efforts) ?? 0                      // 노력치
        let level = Double(state.level) ?? 0                        // 레벨
        let stat = floor(hp + iv/2 + ev/8 + 10 + level)             // 실수치
        print(hp, iv, ev, level)
        return Int(stat)
    }
    /// 방어 실수치 계산
    static func calculateDefenseStat(state: DefenseFeature.State) -> Int {
        let baseStat = Double(state.defenseMode == .physical
                              ? state.pokemonState.pysical
                              : state.pokemonState.special)             // 능력치
        let iv = Double(state.defense_object) ?? 0                      // 개체값
        let ev = Double(state.defense_efforts) ?? 0                     // 노력치
        let personality = state.personality                             // 성격보정
        let stat = floor((baseStat + iv/2 + ev/8 + 5) * personality)    // 실수치
        return Int(stat)
    }
}
