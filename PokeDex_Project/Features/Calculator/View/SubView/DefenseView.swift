//
//  DefenseView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/23/24.
//

import SwiftUI
import ComposableArchitecture

/// 내구력 뷰
struct DefenseView: View {
    typealias DefenseStore = ViewStoreOf<DefenseFeature>
    let store: StoreOf<DefenseFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    formOfAttack(viewStore: viewStore)
                    Spacer()
                    
                    levelTextField(viewStore: viewStore)
                }
                HStack {
                    hpLabel
                    hp_realLabel(viewStore: viewStore)
                }
                hp_effortsView(viewStore: viewStore)
                hp_objectsView(viewStore: viewStore)
                Divider()
                HStack {
                    defenseLabel(viewStore: viewStore)
                    defense_realLabel(viewStore: viewStore)
                }
                
                defense_effortsView(viewStore: viewStore)
                defense_objectsView(viewStore: viewStore)
                
                Divider()
                personalityView(viewStore: viewStore)
                rankUpView(viewStore: viewStore)
                
                durabilityLabel(viewStore: viewStore)
            }
            .padding()
        }
    }
}

// MARK: - 내구력 뷰 컴포넌트 정의
extension DefenseView {
    /// 물리/특수 선택 버튼
    func formOfAttack(viewStore: DefenseStore) -> some View {
        HStack {
            ForEach(AttackCondition.allCases, id: \.rawValue) { filter in
                Button {
                    viewStore.send(.view(.selectedDefense(filter)))
                } label: {
                    Image(filter.rawValue)
                        .resizable()
                        .frame(width: 30, height: 25)
                        .shadow(color: .black, radius: 1)
                        .padding(5)
                        .background {
                            Circle()
                                .foregroundStyle(
                                    viewStore.defenseMode == filter
                                    ? viewStore.pokemonState.types[0].typeColor
                                    : .gray.opacity(0.5)
                                )
                        }
                }
            }
        }
        .padding(.vertical, 10)
        .zIndex(0)
    }
    var hpLabel: some View {
        Text("체력")
            .bold()
            .font(.title3)
    }
    /// 체력 노력치 뷰
    func hp_effortsView(viewStore: DefenseStore) -> some View {
        NumericalCellView(
            title: "노력치",
            color: viewStore.pokemonState.types[0].typeColor,
            arrange: (0...252),
            value: viewStore.binding(
                get: \.hp_efforts,
                send: { .view(.changedHPEfforts($0)) }
            )
        )
    }
    /// 체력 개체값 뷰
    func hp_objectsView(viewStore: DefenseStore) -> some View {
        NumericalCellView(
            title: "개체값",
            color: viewStore.pokemonState.types[0].typeColor,
            arrange: (0...31),
            value: viewStore.binding(
                get: \.hp_object,
                send: { .view(.changedHPObjects($0)) }
            )
        )
    }
    func defenseLabel(viewStore: DefenseStore) -> some View {
        Text(viewStore.defenseMode == .physical ? "방어" : "특방")
            .bold()
            .font(.title3)
    }
    /// 내구 노력치 뷰
    func defense_effortsView(viewStore: DefenseStore) -> some View {
        NumericalCellView(
            title: "노력치",
            color: viewStore.pokemonState.types[0].typeColor,
            arrange: (0...252),
            value: viewStore.binding(
                get: \.defense_efforts,
                send: { .view(.changedDefenseEfforts($0)) }
            )
        )
    }
    /// 내구 개체값 뷰
    func defense_objectsView(viewStore: DefenseStore) -> some View {
        NumericalCellView(
            title: "개체값",
            color: viewStore.pokemonState.types[0].typeColor,
            arrange: (0...31),
            value: viewStore.binding(
                get: \.defense_object,
                send: { .view(.changedDefenseObjects($0)) }
            )
        )
    }
    /// 레벨 입력
    func levelTextField(viewStore: DefenseStore) -> some View {
        HStack {
            Text("LV.")
                .fontWeight(.heavy)
            TextField("레벨", text: viewStore.binding(
                get: \.level,
                send: { .view(.inputtedLevel($0)) })
            )
            .multilineTextAlignment(.trailing)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.numberPad)
            .frame(width: 80)
            .onChange(of: viewStore.level) { newValue in
                viewStore.send(.view(.inputtedLevel(newValue)))
            }
        }
        .font(.device)
    }
    /// 랭크업 뷰
    func rankUpView(viewStore: DefenseStore) -> some View {
        NumericalCellView(
            title: "랭크업",
            color: viewStore.pokemonState.types[0].typeColor,
            arrange: (-6...6),
            value: viewStore.binding(
                get: \.rankUp,
                send: { .view(.changedRankUp($0)) }
            )
        )
    }
    /// 성격 보정 뷰
    func personalityView(viewStore: DefenseStore) -> some View {
        HStack {
            ForEach([0.9, 1, 1.1], id: \.self) { value in
                Button {
                    viewStore.send(.view(.changedPersonality(value)))
                } label: {
                    Text(String(format: "%.1f", value))
                        .foregroundColor(.primary)
                        .fontWeight(viewStore.personality == value
                                    ? .heavy
                                    : .regular)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(15)
        .padding(.vertical, UIScreen.main.bounds.width < 400 ? 2.5 : 0)
        .borderSection(title: "성격 보정")
        .font(.device)
        .frame(maxWidth: .infinity)
    }
    /// 체력실수치 라벨
    func hp_realLabel(viewStore: DefenseStore) -> some View {
        HStack {
            Spacer()
            Text("\(viewStore.hp_real)")
                .fontWeight(.heavy)
                .padding(10)
                .frame(maxWidth: 100)
                .borderSection(title: "실수치")
        }
    }
    /// 실수치 라벨
    func defense_realLabel(viewStore: DefenseStore) -> some View {
        HStack {
            Spacer()
            Text("\(viewStore.defense_real)")
                .fontWeight(.heavy)
                .padding(10)
                .frame(maxWidth: 100)
                .borderSection(title: "실수치")
        }
    }
    /// 내구력 라벨
    func durabilityLabel(viewStore: DefenseStore) -> some View {
        Text("\(viewStore.defense)")
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .borderSection(title: "결정력")
            .padding(.top,30)
    }
}

#Preview {
    let store = Store(
        initialState: DefenseFeature.State(
            pokemonState: PokemonDefenseState(
                type: ["물", "페어리"],
                name: "마릴리",
                hp: 100,
                pysical: 80,
                special: 80
            )
        )) { DefenseFeature() }
    ScrollView {
        DefenseView(store: store)
    }
}


