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
                    multipleView(viewStore: viewStore)
                    statusPicker(viewStore: viewStore)
                }
                .padding(.vertical)
                Divider()
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
    }
}

// MARK: - 공격 결정력 뷰 컴포넌트 정의
private extension PowerView {
    /// 기술 위력 Picker
    func skillPowerPicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.selectedPower,
                send: { .selectedPower($0) }
            ),
            options: Array(stride(from: 10, through: 250, by: 5).map{ "\($0)" }),
            color: viewStore.value.type[0].typeColor
        )
        .borderSection(title: "기술 위력")
        .frame(maxWidth: .infinity)
    }
    /// 타입 피커
    func typePicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.selectedType,
                send: { .selectedType($0) }
            ),
            options: TypeFilter.allCases.map(\.rawValue),
            color: viewStore.value.type[0].typeColor
        )
        .borderSection(title: "타입")
        .frame(width: 120)
    }
    /// 물리/특수 선택 버튼
    func formOfAttack(viewStore: PowerStore) -> some View {
        HStack {
            ForEach(AttackFilter.allCases, id: \.rawValue) { filter in
                Button {
                    viewStore.send(.selectedAttack(filter))
                } label: {
                    Image(filter.rawValue)
                        .resizable()
                        .frame(width: 30, height: 25)
                        .shadow(color: .black, radius: 1)
                        .padding(5)
                        .background {
                            Circle()
                                .foregroundStyle(
                                    viewStore.selectedAttack == filter
                                    ? viewStore.value.type[0].typeColor
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
        CheckBox(label: "테라스탈", color: viewStore.value.type[0].typeColor, isChecked: viewStore.isChecked) {
            viewStore.send(.checkedTherastal)
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
                send: { .inputtedLevel($0) })
            )
            .multilineTextAlignment(.trailing)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.numberPad)
            .frame(width: 80)
            .onChange(of: viewStore.level) { newValue in
                viewStore.send(.inputtedLevel(newValue))
            }
        }
        .zIndex(0)
    }
    /// 노력치 뷰
    func effortsView(viewStore: PowerStore) -> some View {
        NumericalCellView(
            title: "노력치",
            color: viewStore.value.type[0].typeColor,
            arrange: (0...252),
            value: viewStore.binding(
                get: \.efforts,
                send: { .changedEfforts($0) }
            )
        )
    }
    /// 노력치 뷰
    func objectsView(viewStore: PowerStore) -> some View {
        NumericalCellView(
            title: "개체값",
            color: viewStore.value.type[0].typeColor,
            arrange: (0...31),
            value: viewStore.binding(
                get: \.object,
                send: { .changedObjects($0) }
            )
        )
    }
    /// 랭크업 뷰
    func rankUpView(viewStore: PowerStore) -> some View {
        NumericalCellView(
            title: "랭크업",
            color: viewStore.value.type[0].typeColor,
            arrange: (-6...6),
            value: viewStore.binding(
                get: \.rankUp,
                send: { .changedRankUp($0) }
            )
        )
    }
    /// 성격 보정 뷰
    func personalityView(viewStore: PowerStore) -> some View {
        HStack {
            ForEach([0.9, 1, 1.1], id: \.self) { value in
                Button {
                    
                } label: {
                    Text(String(format: "%.1f", value))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(10)
        .borderSection(title: "성격 보정")
        .frame(width: 150)
    }
    /// 배수 뷰
    func multipleView(viewStore: PowerStore) -> some View {
        TextField("", text: viewStore.binding(
            get: \.multiple,
            send: { .inputtedMultiple($0) })
        )
        .padding(10)
        .borderSection(title: "배수")
        .frame(width: 70)
    }
    /// 상태이상 피커
    func statusPicker(viewStore: PowerStore) -> some View {
        CustomPicker(
            selected: viewStore.binding(
                get: \.selectedStatus,
                send: { .selectedStatus($0) }
            ),
            options: StatusFilter.allCases.map(\.rawValue),
            color: viewStore.value.type[0].typeColor
        )
        .borderSection(title: "상태 이상")
    }
}

#Preview {
    let value = PowerValue(type: ["드래곤", "비행"], power: 81, special_attack: 74)
    let store = Store(initialState: PowerFeature.State(value: value)) { PowerFeature() }
    ScrollView {
        PowerView(store: store)
    }
}
