//
//  PowerFeature.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/30/25.
//

import Foundation
import ComposableArchitecture

/// 공격 결정력 계산 Feature
struct PowerFeature: Reducer {
    
    @ObservableState struct State: Equatable {
        var value: PokemonValue
        var selectedPower: Int = 0
        var selectedType: String = TypeFilter.normal.rawValue
        var selectedAttack: AttackCategory = .physical
        var selectedStatus: String = StatusCondition.none.koreanName
        var isChecked: Bool = false
        var level: String = "\(1)"
        var efforts: String = "\(252)"
        var object: String = "\(31)"
        var rankUp: String = "\(0)"
        var multiple: String = "\(1)"
        var personality: Double = 1.0
        var selectedAbility: String = PokemonAbility.none.koreanName
        var selectedWeather: String = WeatherCondition.none.koreanName
        var selectedItem: String = PokemonItem.none.koreanName
        var selectedField: String = TerrainCondition.none.koreanName
        var selectedCheckbox: [BattleModifierType: Bool] = Dictionary(uniqueKeysWithValues: BattleModifierType.allCases.map { ($0, false)})
        var damange: Int = 0
    }
    
    @CasePathable enum Action: Equatable {
        case selectedPower(_ power: Int)
        case selectedType(_ type: String)
        case inputtedLevel(_ level: String)
        case selectedAttack(_ attack: AttackCategory)
        case changedEfforts(_ efforts: String)
        case changedObjects(_ object: String)
        case changedRankUp(_ rankUp: String)
        case inputtedMultiple(_ multiple: String)
        case selectedStatus(_ status: String)
        case changedPersonality(_ personality: Double)
        case selectedAbility(_ ability: String)
        case selectedWeather(_ weather: String)
        case selectedItem(_ weather: String)
        case selectedField(_ weather: String)
        case checkedOhter(_ other: BattleModifierType)
        case checkedTherastal
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectedPower(power):
                return updatePower(&state, power: power)
            case let .selectedType(type):
                return updateType(&state, type: type)
            case let .inputtedLevel(level):
                return updateLevel(&state, level: level)
            case .checkedTherastal:
                return updateTherastal(&state)
            case let .selectedAttack(attack):
                return updateAttack(&state, attack: attack)
            case let .changedEfforts(effort):
                return updateEffort(&state, effort: effort)
            case let .changedObjects(object):
                return updateObject(&state, object: object)
            case let .changedRankUp(rankUp):
                return updateRankUp(&state, rankUp: rankUp)
            case let .inputtedMultiple(multiple):
                return updateMultiple(&state, multiple: multiple)
            case let .selectedStatus(status):
                return updateStatus(&state, status: status)
            case let .changedPersonality(personality):
                return updatePersonality(&state, personality: personality)
            case let .selectedAbility(ability):
                return updateAbility(&state, ability: ability)
            case let .selectedWeather(weather):
                return updateWeather(&state, weather: weather)
            case let .selectedItem(tool):
                return updateItem(&state, tool: tool)
            case let .selectedField(field):
                return updateField(&state, field: field)
            case let .checkedOhter(other):
                return updateOthers(&state, other: other)
            }
        }
    }
    
    private func updatePower(_ state: inout State, power: Int) -> Effect<Action> {
        state.selectedPower = power
        return .none
    }
    private func updateType(_ state: inout State, type: String) -> Effect<Action> {
        state.selectedType = type
        return .none
    }
    private func updateAttack(_ state: inout State, attack: AttackCategory) -> Effect<Action> {
        state.selectedAttack = attack
        return .none
    }
    private func updateTherastal(_ state: inout State) -> Effect<Action> {
        state.isChecked.toggle()
        return .none
    }
    private func updateLevel(_ state: inout State, level: String) -> Effect<Action> {
        guard let level = level.extractNumber,
              (1...100) ~= level else {
            state.level = "1"
            return .none
        }
        state.level = "\(level)"
        return .none
    }
    private func updateEffort(_ state: inout State, effort: String) -> Effect<Action> {
        state.efforts = effort
        return .none
    }
    private func updateObject(_ state: inout State, object: String) -> Effect<Action> {
        state.object = object
        return .none
    }
    private func updateRankUp(_ state: inout State, rankUp: String) -> Effect<Action> {
        state.rankUp = rankUp
        return .none
    }
    private func updateMultiple(_ state: inout State, multiple: String) -> Effect<Action> {
        state.multiple = multiple
        return .none
    }
    private func updateStatus(_ state: inout State, status: String) -> Effect<Action> {
        state.selectedStatus = status
        return .none
    }
    private func updatePersonality(_ state: inout State, personality: Double) -> Effect<Action> {
        state.personality = personality
        return .none
    }
    private func updateAbility(_ state: inout State, ability: String) -> Effect<Action> {
        state.selectedAbility = ability
        return .none
    }
    private func updateWeather(_ state: inout State, weather: String) -> Effect<Action> {
        state.selectedWeather = weather
        return .none
    }
    private func updateItem(_ state: inout State, tool: String) -> Effect<Action> {
        state.selectedItem = tool
        return .none
    }
    private func updateField(_ state: inout State, field: String) -> Effect<Action> {
        state.selectedField = field
        return .none
    }
    private func updateOthers(_ state: inout State, other: BattleModifierType) -> Effect<Action> {
        state.selectedCheckbox[other]?.toggle()
        return .none
    }
}

struct PokemonValue: Equatable {
    let type: [String]
    let pysical: Int
    let special: Int
}
