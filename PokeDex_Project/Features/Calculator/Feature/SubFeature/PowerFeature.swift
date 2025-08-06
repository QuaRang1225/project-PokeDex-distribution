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
        var level: String = "\(1)"
        var efforts: String = "\(252)"
        var object: String = "\(31)"
        var personality: Double = 1.0
        var pokemonState: PokemonState
        
        var power: Int {
            Int(
                PowerFeature.calculatePower(state: self) *
                Double(PowerFeature.calculateStat(state: self)) *
                Double(pokemonState.power) *
                stab * rankUp * isTherastal
            )
        }
        /// 자속 여부
        var isStab: Bool {
            pokemonState.types.contains(pokemonState.type)
        }
        /// 자속 보정
        var stab: Double {
            isStab ? 1.5 : 1.0
        }
        /// 랭크업 여부
        var rankUp: Double {
            Double(pokemonState.rankUp)?.calculateRankMultiplier ?? 0
        }
        /// 테라스탈 여부
        var isTherastal: Double {
            if isStab {
                pokemonState.isTherastal ? (4/3) : 1.0
            } else {
                pokemonState.isTherastal ? 1.5 : 1.0
            }
        }
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
        state.pokemonState.power = power
        return .none
    }
    private func updateType(_ state: inout State, type: String) -> Effect<Action> {
        state.pokemonState.type = type
        return .none
    }
    private func updateAttack(_ state: inout State, attack: AttackCategory) -> Effect<Action> {
        state.pokemonState.attackedMode = attack
        return .none
    }
    private func updateTherastal(_ state: inout State) -> Effect<Action> {
        state.pokemonState.isTherastal.toggle()
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
        state.pokemonState.rankUp = rankUp
        return .none
    }
    private func updateMultiple(_ state: inout State, multiple: String) -> Effect<Action> {
        state.pokemonState.multiple = multiple
        return .none
    }
    private func updateStatus(_ state: inout State, status: String) -> Effect<Action> {
        state.pokemonState.status = status
        return .none
    }
    private func updatePersonality(_ state: inout State, personality: Double) -> Effect<Action> {
        state.personality = personality
        return .none
    }
    private func updateAbility(_ state: inout State, ability: String) -> Effect<Action> {
        state.pokemonState.ability = ability
        return .none
    }
    private func updateWeather(_ state: inout State, weather: String) -> Effect<Action> {
        state.pokemonState.weather = weather
        return .none
    }
    private func updateItem(_ state: inout State, tool: String) -> Effect<Action> {
        state.pokemonState.item = tool
        return .none
    }
    private func updateField(_ state: inout State, field: String) -> Effect<Action> {
        state.pokemonState.field = field
        return .none
    }
    private func updateOthers(_ state: inout State, other: BattleModifierType) -> Effect<Action> {
        state.pokemonState.battleModifier[other]?.toggle()
        return .none
    }
    
    
}

// MARK: - 전역 메서드
extension PowerFeature {
    /// 실수치 계산
    static func calculateStat(state: PowerFeature.State) -> Int {
        
        let baseStat = Double(state.pokemonState.attackedMode == .physical ? state.value.pysical : state.value.special)    // 능력치
        let iv = Double(state.object) ?? 0      // 개체값
        let ev = Double(state.efforts) ?? 0     // 노력치
        let personality = state.personality     // 성격보정
        let stat = floor((baseStat + iv/2 + ev/8 + 5) * personality) // 실 수치
        return Int(stat)
    }
    /// 결정력 계산
    static func calculatePower(state: PowerFeature.State) -> Double {
        var mutableState = state.pokemonState
        
        // 1. 배틀 모디파이어 적용
        let activeModifiers = mutableState.battleModifier.filter { $0.value }.map { $0.key }
        for modifier in activeModifiers {
            mutableState = modifier.calculate(state: &mutableState)
        }
        
        // 2. 날씨
        if let weather = WeatherCondition(rawValue: mutableState.weather) {
            mutableState = weather.calculate(state: &mutableState)
        }
        
        // 3. 상성 배율
        if let multiple = CompatibilityCategory(rawValue: mutableState.multiple) {
            mutableState = multiple.calculate(state: &mutableState)
        }
        
        // 4. 상태이상
        if let status = StatusCondition(rawValue: mutableState.status) {
            mutableState = status.calculate(state: &mutableState)
        }
        
        // 5. 필드
        if let field = TerrainCondition(rawValue: mutableState.field) {
            mutableState = field.calculate(state: &mutableState)
        }
        
        // 6. 아이템
        if let item = PokemonItem(rawValue: mutableState.item) {
            mutableState = item.calculate(state: &mutableState)
        }
        
        // 7. 특성
        if let ability = PokemonAbility(rawValue: mutableState.ability) {
            mutableState = ability.calculate(state: &mutableState)
        }
        
        return mutableState.result
    }
}



