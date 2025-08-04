//
//  CalculateView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/21/24.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

/// 계산기 뷰
struct CalculateView: View {
    typealias CalculatorStore = ViewStoreOf<CalculatorFeature>
    let store: StoreOf<CalculatorFeature>
    
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                titleLabel
                    .overlay(alignment: .leading) {
                        dismissButton(viewStore: viewStore)
                    }
                Divider()
                    .padding(.top)
                ScrollView(.vertical, showsIndicators: false) {
                    pokemonImageView(viewStore: viewStore)
                    nameLabel(viewStore: viewStore)
                    typesView(viewStore: viewStore)
                    statsView(viewStore: viewStore)
                    modeHandlerView(viewStore: viewStore)
                    if viewStore.mode == .power {
                        powerView()
                    } else {
                        defenseView()
                    }
                }
            }
            .onDidLoad {
                viewStore.send(.viewDidLoad)
            }
        }
    }
}

// MARK: - 계산기 뷰 컴포넌트 정의
private extension CalculateView{
    /// 닫기 버튼
    func dismissButton(viewStore: CalculatorStore) -> some View {
        Button {
            viewStore.send(.delegate(.didTappedDismissButton))
        } label: {
            Image(systemName: "chevron.left")
        }
        .foregroundColor(.primary)
        .padding(.leading)
    }
    /// 타이틀 라벨
    var titleLabel: some View {
        Text("계산기")
            .bold()
            .frame(maxWidth: .infinity)
    }
    /// 이미지 뷰
    func pokemonImageView(viewStore: CalculatorStore) -> some View {
        KFImage(URL(string: viewStore.pokemonInfo.image))
            .resizable()
            .frame(width: 100, height: 100)
    }
    /// 타이틀 라벨
    func nameLabel(viewStore: CalculatorStore) -> some View {
        Text(viewStore.pokemonInfo.name)
    }
    /// 타입 뷰
    func typesView(viewStore: CalculatorStore) -> some View {
        HStack(spacing: 8) {
            ForEach(viewStore.pokemonInfo.types, id: \.self) { type in
                TypesView(type: type, width: 75, height: 25, font: .body)
            }
        }
    }
    /// 스탯 뷰
    func statsView(viewStore: CalculatorStore) -> some View {
        VStack {
            Text("종족값")
                .bold()
            HStack {
                let title = ["HP", "공격", "방어", "특공", "특방", "스피드", "합계"]
                let content = viewStore.pokemonInfo.stats.addSum
                
                ForEach(Array(zip(title, content)), id: \.0) { title, content in
                    VStack(spacing: 5) {
                        Text(title)
                            .font(.subheadline)
                            .bold()
                        Text("\(content)")
                            .fontWeight(title == "합계" ? .heavy : .regular)
                            .foregroundStyle(
                                content >= 150 && title != "합계" ?
                                    .red : .primary
                            )
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
            }
        }
        .padding()
    }
    /// 모드 선택 뷰
    func modeHandlerView(viewStore: CalculatorStore) -> some View {
        HStack {
            Button {
                viewStore.send(.selectedMode(.power))
            } label: {
                Text("공격")
                    .frame(maxWidth: .infinity)
            }
            Button {
                viewStore.send(.selectedMode(.defense))
            } label: {
                Text("방어")
                    .frame(maxWidth: .infinity)
            }
        }
        .overlay(
            alignment: viewStore.mode == .power
            ? .bottomLeading
            : .bottomTrailing
        ) {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: UIScreen.main.bounds.width / 2, height: 2)
                .offset(y: 10)
                .animation(.default, value: viewStore.mode)
        }
        .foregroundColor(.primary)
    }
    func powerView() -> some View {
        IfLetStore(store.scope(
            state: \.powerState,
            action: \.powerAction
        )) { store in
            PowerView(store: store)
        }
        .padding(.top, 30)
    }
    func defenseView() -> some View {
        IfLetStore(store.scope(
            state: \.defenseState,
            action: \.defenseAction
        )) { store in
//            DefenseView(store: store)
        }
    }
}

#Preview {
    let info = CustomData.instance.pokemonInfo
    let store = Store(initialState: CalculatorFeature.State(pokemonInfo: info)) { CalculatorFeature() }
    CalculateView(store: store)
}
