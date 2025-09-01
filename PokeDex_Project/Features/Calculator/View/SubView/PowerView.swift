//
//  PowerView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/23/24.
//
import SwiftUI
import Kingfisher
import ComposableArchitecture

/// 공격 결정력 뷰
struct PowerView: View {
    typealias PowerStore = ViewStoreOf<PowerFeature>
    let store: StoreOf<PowerFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    skillPowerPicker(viewStore: viewStore)
                    typePicker(viewStore: viewStore)
                }
                HStack {
                    formOfAttack(viewStore: viewStore)
                    therastalStatusCheckBox(viewStore: viewStore)
                    Spacer()
                    levelTextField(viewStore: viewStore)
                }
                effortsView(viewStore: viewStore)
                objectsView(viewStore: viewStore)
                rankUpView(viewStore: viewStore)
                HStack {
                    personalityView(viewStore: viewStore)
                    statusPicker(viewStore: viewStore)
                    
                }
                HStack {
                    multipleView(viewStore: viewStore)
                    realLabel(viewStore: viewStore)
                }
                Divider()
                    .padding(.vertical, 5)
                HStack {
                    weatherPicker(viewStore: viewStore)
                    abilityPicker(viewStore: viewStore)
                }
                HStack {
                    fieldPicker(viewStore: viewStore)
                    itemPicker(viewStore: viewStore)
                }
                otherOptionChckboxs(viewStore: viewStore)
                damageLabel(viewStore: viewStore)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - 공격 결정력 뷰 컴포넌트 정의
private extension PowerView {
    /// 기술 위력 Picker
    func skillPowerPicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.pokemonState.power,
                send: { .view(.selectedPower($0)) }
            ),
            options: Array(stride(from: 10, through: 250, by: 5).map{ "\($0)" }),
            color: viewStore.pokemonState.types[0].typeColor
        )
        .borderSection(title: "기술 위력")
        .frame(maxWidth: .infinity)
    }
    /// 타입 피커
    func typePicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.pokemonState.type,
                send: { .view(.selectedType($0)) }
            ),
            options: TypeFilter.allCases.map(\.rawValue),
            color: viewStore.pokemonState.types[0].typeColor
        )
        .borderSection(title: "타입")
        .frame(width: 120)
    }
    /// 물리/특수 선택 버튼
    func formOfAttack(viewStore: PowerStore) -> some View {
        HStack {
            ForEach(AttackCondition.allCases, id: \.rawValue) { filter in
                Button {
                    viewStore.send(.view(.selectedAttack(filter)))
                } label: {
                    Image(filter.rawValue)
                        .resizable()
                        .frame(width: 30, height: 25)
                        .shadow(color: .black, radius: 1)
                        .padding(5)
                        .background {
                            Circle()
                                .foregroundStyle(
                                    viewStore.pokemonState.attackedMode == filter
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
    /// 테라스탈 여부 체크 박스
    func therastalStatusCheckBox(viewStore: PowerStore) -> some View {
        CheckBox(
            label: "테라스탈",
            color: viewStore.pokemonState.types[0].typeColor,
            isChecked: viewStore.pokemonState.isTherastal) {
                viewStore.send(.view(.checkedTherastal))
        }
        .padding(.leading)
        .zIndex(0)
    }
    /// 레벨 입력
    func levelTextField(viewStore: PowerStore) -> some View {
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
    /// 노력치 뷰
    func effortsView(viewStore: PowerStore) -> some View {
        NumericalCellView(
            title: "노력치",
            color: viewStore.pokemonState.types[0].typeColor,
            arrange: (0...252),
            value: viewStore.binding(
                get: \.efforts,
                send: { .view(.changedEfforts($0)) }
            )
        )
    }
    /// 개체값 뷰
    func objectsView(viewStore: PowerStore) -> some View {
        NumericalCellView(
            title: "개체값",
            color: viewStore.pokemonState.types[0].typeColor,
            arrange: (0...31),
            value: viewStore.binding(
                get: \.object,
                send: { .view(.changedObjects($0)) }
            )
        )
    }
    /// 랭크업 뷰
    func rankUpView(viewStore: PowerStore) -> some View {
        NumericalCellView(
            title: "랭크업",
            color: viewStore.pokemonState.types[0].typeColor,
            arrange: (-6...6),
            value: viewStore.binding(
                get: \.pokemonState.rankUp,
                send: { .view(.changedRankUp($0)) }
            )
        )
    }
    /// 성격 보정 뷰
    func personalityView(viewStore: PowerStore) -> some View {
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
        .padding(10)
        .padding(.vertical, UIScreen.main.bounds.width < 400 ? 2.5 : 0)
        .borderSection(title: "성격 보정")
        .font(.device)
        .frame(width: 150)
    }
    /// 배수 뷰
    func multipleView(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.pokemonState.compatibility,
                send: { .view(.inputtedCompatibility($0)) }
            ),
            options: CompatibilityCondition.allCases.map(\.rawValue),
            color: viewStore.pokemonState.types[0].typeColor
        )
        .borderSection(title: "효과")
        .frame(width: 250)
    }
    /// 상태이상 피커
    func statusPicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.pokemonState.status,
                send: { .view(.selectedStatus($0)) }
            ),
            options: StatusCondition.allCases.map(\.rawValue),
            color: viewStore.pokemonState.types[0].typeColor
        )
        .borderSection(title: "상태 이상")
    }
    /// 특성 피커
    func abilityPicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.pokemonState.ability,
                send: { .view(.selectedAbility($0)) }
            ),
            options: AbilityCondition.allCases.map(\.rawValue),
            color: viewStore.pokemonState.types[0].typeColor
        )
        .borderSection(title: "특성")
        .frame(width: 220)
    }
    /// 날씨 피커
    func weatherPicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.pokemonState.weather,
                send: { .view(.selectedWeather($0)) }
            ),
            options: WeatherCondition.allCases.map(\.rawValue),
            color: viewStore.pokemonState.types[0].typeColor
        )
        .borderSection(title: "날씨")
    }
    /// 아이템 피커
    func itemPicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.pokemonState.item,
                send: { .view(.selectedItem($0)) }
            ),
            options: ItemCondition.allCases.map(\.rawValue),
            color: viewStore.pokemonState.types[0].typeColor
        )
        .borderSection(title: "도구")
        .frame(width: 200)
    }
    /// 필드 피커
    func fieldPicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.pokemonState.field,
                send: { .view(.selectedField($0)) }
            ),
            options: FieldCondition.allCases.map(\.rawValue),
            color: viewStore.pokemonState.types[0].typeColor
        )
        .borderSection(title: "필드")
    }
    /// 실수치 라벨
    func realLabel(viewStore: PowerStore) -> some View {
        Text("\(viewStore.real)")
            .fontWeight(.heavy)
            .padding(10)
            .frame(maxWidth: .infinity)
            .borderSection(title: "실수치")
    }
    /// 옵션 선택 체크 박스
    func otherOptionChckboxs(viewStore: PowerStore) -> some View {
        VStack {
            let columns = Array(repeating: GridItem(.flexible()), count: 3)
            LazyVGrid(columns: columns, alignment: .leading) {
                ForEach(BattleCondition.allCases, id: \.rawValue) { option in
                    if let checkbox = viewStore.pokemonState.battleModifier[option] {
                        CheckBox(
                            label: option.koreanName,
                            color: viewStore.pokemonState.types[0].typeColor,
                            isChecked: checkbox) {
                                viewStore.send(.view(.checkedBattleModifiers(option)))
                            }
                    }
                }
            }
        }
    }
    /// 결정력 라벨
    func damageLabel(viewStore: PowerStore) -> some View {
        Text("\(viewStore.power)")
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .borderSection(title: "결정력")
    }
}

#Preview {
    let store = Store(
        initialState: PowerFeature.State(
            pokemonState: PokemonAttckState(
                type: ["물", "페어리"],
                name: "마릴리",
                pysical: 50,
                special: 60
            )
        )) { PowerFeature() }
    ScrollView {
        PowerView(store: store)
    }
}
