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
        var level: String = "\(1)"      // 레벨
        var efforts: String = "\(252)"  // 노력치
        var object: String = "\(31)"    // 개체값
        var personality: Double = 1.0   // 성격
        var pokemonState: PokemonAttckState  // 상태
        
        /// 실수치
        var real: Int {
            PowerFeature.calculateStat(state: self)
        }
        
        /// 결정력 = [실수치 x 포켓몬 상태] x [기술위력 x 자속 x 랭크업 x 테라스탈]
        var power: Int {
            Int(pokemonState.addMutiple) * real * Int(PowerFeature.calculatePower(state: self))
        }
    }
    
    @CasePathable enum Action: Equatable {
        case selectedPower(_ power: Int)                                        // 위력 선택
        case inputtedLevel(_ level: String)                                     // 레벨 선택
        case changedEfforts(_ efforts: String)                                  // 노력치 선택
        case changedObjects(_ object: String)                                   // 개체값 선택
        case changedRankUp(_ rankUp: String)                                    // 랭크업 선택
        case changedPersonality(_ personality: Double)                          // 성격 선택
        case selectedType(_ type: TypeFilter)                                   // 타입 선택
        case selectedAttack(_ attack: AttackCondition)                          // 물리/특공 선택
        case inputtedCompatibility(_ compatibility: CompatibilityCondition)     // 상성 선택
        case selectedStatus(_ status: StatusCondition)                          // 상태이상 선택
        case selectedAbility(_ ability: AbilityCondition)                       // 특성 선택
        case selectedWeather(_ weather: WeatherCondition)                       // 날씨 선택
        case selectedItem(_ item: ItemCondition)                                // 아이템 선택
        case selectedField(_ field: FieldCondition)                             // 필드 선택
        case checkedBattleModifiers(_ other: BattleCondition)                   // 배들상태 선택
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
            case let .inputtedCompatibility(compatibility):
                return updateCompatibility(&state, compatibility: compatibility)
            case let .selectedStatus(status):
                return updateStatus(&state, status: status)
            case let .changedPersonality(personality):
                return updatePersonality(&state, personality: personality)
            case let .selectedAbility(ability):
                return updateAbility(&state, ability: ability)
            case let .selectedWeather(weather):
                return updateWeather(&state, weather: weather)
            case let .selectedItem(item):
                return updateItem(&state, item: item)
            case let .selectedField(field):
                return updateField(&state, field: field)
            case let .checkedBattleModifiers(other):
                return updateBattleModifiers(&state, other: other)
            }
        }
    }
    /// 위력 업데이트
    private func updatePower(_ state: inout State, power: Int) -> Effect<Action> {
        state.pokemonState.power = power
        return .none
    }
    /// 타입 업데이트
    private func updateType(_ state: inout State, type: TypeFilter) -> Effect<Action> {
        state.pokemonState.type = type
        return .none
    }
    /// 물리/특공 업데이트
    private func updateAttack(_ state: inout State, attack: AttackCondition) -> Effect<Action> {
        state.pokemonState.attackedMode = attack
        return .none
    }
    /// 테라스탈 업데이트
    private func updateTherastal(_ state: inout State) -> Effect<Action> {
        state.pokemonState.isTherastal.toggle()
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
    /// 노력치 업데이트
    private func updateEffort(_ state: inout State, effort: String) -> Effect<Action> {
        state.efforts = effort
        return .none
    }
    /// 개체값 업데이트
    private func updateObject(_ state: inout State, object: String) -> Effect<Action> {
        state.object = object
        return .none
    }
    /// 랭크업 업데이트
    private func updateRankUp(_ state: inout State, rankUp: String) -> Effect<Action> {
        state.pokemonState.rankUp = rankUp
        return .none
    }
    /// 상성 업데이트
    private func updateCompatibility(_ state: inout State, compatibility: CompatibilityCondition) -> Effect<Action> {
        state.pokemonState.compatibility = compatibility
        return .none
    }
    /// 상태이상 업데이트
    private func updateStatus(_ state: inout State, status: StatusCondition) -> Effect<Action> {
        state.pokemonState.status = status
        return .none
    }
    /// 성격 업데이트
    private func updatePersonality(_ state: inout State, personality: Double) -> Effect<Action> {
        state.personality = personality
        return .none
    }
    /// 특성 업데이트
    private func updateAbility(_ state: inout State, ability: AbilityCondition) -> Effect<Action> {
        state.pokemonState.ability = ability
        return .none
    }
    /// 날씨 업데이트
    private func updateWeather(_ state: inout State, weather: WeatherCondition) -> Effect<Action> {
        state.pokemonState.weather = weather
        return .none
    }
    /// 아이템 업데이트
    private func updateItem(_ state: inout State, item: ItemCondition) -> Effect<Action> {
        state.pokemonState.item = item
        return .none
    }
    /// 필드 업데이트
    private func updateField(_ state: inout State, field: FieldCondition) -> Effect<Action> {
        state.pokemonState.field = field
        return .none
    }
    /// 배틀상태 업데이트
    private func updateBattleModifiers(_ state: inout State, other: BattleCondition) -> Effect<Action> {
        state.pokemonState.battleModifier[other]?.toggle()
        return .none
    }
}

// MARK: - 전역 메서드
extension PowerFeature {
    /// 실수치 계산
    static func calculateStat(state: PowerFeature.State) -> Int {
        let baseStat = Double(state.pokemonState.attackedMode == .physical ? state.pokemonState.pysical : state.pokemonState.special)    // 능력치
        let iv = Double(state.object) ?? 0      // 개체값
        let ev = Double(state.efforts) ?? 0     // 노력치
        let personality = state.personality     // 성격보정
        let stat = floor((baseStat + iv/2 + ev/8 + 5) * personality) // 실수치
        return Int(stat)
    }
    /// ## 결정력 계산
    /// - 여기서 상태가 변할 때마다 새로 업데이트를 해주지 않으면 곱한 상태에 계속 값이 곱셈됨 (이전에 입력한 거에 추가로 곱하게 됨)
    static func calculatePower(state: PowerFeature.State) -> Double {
        var mutableState = state.pokemonState
        
        // 1. 배틀 모디파이어 적용
        let activeModifiers = mutableState.battleModifier.filter { $0.value }.map { $0.key }
        for modifier in activeModifiers {
            mutableState = modifier.calculate(state: &mutableState)
        }
        
        // 2. 날씨
        mutableState = mutableState.weather.calculate(state: &mutableState)
        // 3. 상성 배율
        mutableState = mutableState.compatibility.calculate(state: &mutableState)
        // 4. 상태이상
        mutableState = mutableState.status.calculate(state: &mutableState)
        // 5. 필드
        mutableState = mutableState.field.calculate(state: &mutableState)
        // 6. 아이템
        mutableState = mutableState.item.calculate(state: &mutableState)
        // 7. 특성
        mutableState = mutableState.ability.calculate(state: &mutableState)
        
        return mutableState.result
    }
}



