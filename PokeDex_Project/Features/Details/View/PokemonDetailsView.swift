//
//  PokemonView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

/// 포켓몬 상세화면
struct PokemonDetailsView: View {
    typealias PokemonDetailsStore = ViewStoreOf<PokemonDetailsFeature>
    let store: StoreOf<PokemonDetailsFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                if !viewStore.state.isLoading {
                    HStack {
                        dismissButton(viewStore: viewStore)
                        Spacer()
                        heartButton(viewStore: viewStore)
                    }
                    .padding(.horizontal)
                    .overlay {
                        titleLabel(viewStore: viewStore)
                    }
                }
                adMobsView
                if viewStore.state.isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(2.0)
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack {
                            previousPokemonButton(viewStore: viewStore)
                            pokemonImageView(viewStore: viewStore)
                            nextPokemonButton(viewStore: viewStore)
                        }
                        typesView(viewStore: viewStore)
                        formsView(viewStore: viewStore)
                        pokemonInfoView(viewStore: viewStore)
                        statsView(viewStore: viewStore)
                        calculatorButton(viewStore: viewStore)
                        passiveView(viewStore: viewStore)
                        eveolutionTreeView(viewStore: viewStore)
                        descriptionView(viewStore: viewStore)
                    }
                }
            }
            .onDidLoad {
                viewStore.send(.view(.viewDidLoad))
            }
            .navigationDestination(
                store: store.scope(
                    state: \.$calculatorState,
                    action: \.child.calculatorAction
                )
            ) { calculatorStore in
                calculatorView(calculatorStore: calculatorStore)
            }
        }
    }
}

// MARK: - 포켓몬 상세화면 컴포넌트 정의
extension PokemonDetailsView {
    /// 헤더 뷰
    private func dismissButton(viewStore: PokemonDetailsStore) -> some View {
        Button {
            viewStore.send(.view(.didTappedBackButton))
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "chevron.left")
                Label {
                    Text(String(format: "%04d", viewStore.state.pokemon?.id ?? 0))
                } icon: {
                    KFImage(URL(string: String.mosterBallImageURL))
                }
            }
        }
        .foregroundStyle(.primary)
    }
    /// 포켓몬 이름
    private func titleLabel(viewStore: PokemonDetailsStore) -> some View {
        Text(viewStore.state.pokemon?.name ?? "")
            .bold()
    }
    /// 하트 버튼
    private func heartButton(viewStore: PokemonDetailsStore) -> some View {
        Button {
            viewStore.send(.view(.didTappedHeartButton))
        } label: {
            Image(systemName: viewStore.state.isBookmarked ? "heart.fill" : "heart")
        }
        .foregroundStyle(.pink)
    }
    /// 광고 배너
    @ViewBuilder
    private var adMobsView: some View {
        let adUnitId = Bundle.main.infoDictionary?["SDK_ID"] as! String
        AdBannerView(adUnitID: adUnitId)
            .frame(height: 44)
    }
    /// 포켓몬 이미지 뷰
    private func pokemonImageView(viewStore: PokemonDetailsStore) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.gray.opacity(0.1))
                .overlay {
                    Rectangle()
                        .frame(height: 20)
                        .foregroundColor(.systemBackground)
                    Circle()
                        .foregroundColor(.systemBackground)
                        .frame(width: 60,height: 60)
                }
            KFImage(URL(string: viewStore.state.variety?.form.images.first ?? ""))
                .resizable()
        }
        .frame(
            width: UIScreen.main.bounds.width/1.5,
            height: UIScreen.main.bounds.width/1.5
        )
        .padding(.vertical)
    }
    /// 이전 포켓몬 이동 버튼
    private func previousPokemonButton(viewStore: PokemonDetailsStore) -> some View {
        Button {
            viewStore.send(.view(.didTappedPrevious))
        } label: {
            Image(systemName: "chevron.backward.circle.fill")
                .font(.title)
                .foregroundStyle(.gray)
        }
    }
    /// 다음 포켓몬 이동 버튼
    private func nextPokemonButton(viewStore: PokemonDetailsStore) -> some View {
        Button {
            viewStore.send(.view(.didTappedNext))
        } label: {
            Image(systemName: "chevron.right.circle.fill")
                .font(.title)
                .foregroundStyle(.gray)
        }
    }
    /// 타입 뷰
    private func typesView(viewStore: PokemonDetailsStore) -> some View {
        HStack(spacing: 8) {
            ForEach(viewStore.variety?.types ?? [], id:\.self) { type in
                TypesView(type: type, width: 100, height: 25, font: .body)
            }
        }
    }
    /// 다른 폼 뷰
    @ViewBuilder
    private func formsView(viewStore: PokemonDetailsStore) -> some View {
        if viewStore.state.varieties.count > 1 {
            VStack(alignment: .leading) {
                Text("다른 모습")
                    .bold()
                    .padding(.leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewStore.state.varieties, id: \.id) { variety in
                            Button {
                                viewStore.send(.view(.didTappedVarietyCell(variety)))
                            } label: {
                                VStack {
                                    KFImage(URL(string: variety.form.images.first ?? ""))
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text(variety.form.name.first.unWrapOrDefault("기본"))
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                                .opacity(
                                    viewStore.state.variety == variety ?
                                    1 : 0.5
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    /// 포켓몬 정보 뷰
    private func pokemonInfoView(viewStore: PokemonDetailsStore) -> some View {
        VStack(spacing: 30) {
            InfoRowView(items: [
                ("분류", [viewStore.state.pokemon?.genra ?? ""]),
                ("키", ["\(viewStore.state.variety?.height ?? 0)m"]),
                ("무게", ["\(viewStore.state.variety?.weight ?? 0)kg"]),
                ("포획률", ["\(viewStore.state.pokemon?.captureRate ?? 0)"])
            ], color: viewStore.state.variety?.types.first?.typeColor)
            
            InfoRowView(items: [
                ("알그룹", viewStore.state.pokemon?.eggGroup ?? []),
                ("성비", viewStore.state.pokemon?.genderRate?.genderRate ?? []),
                ("부화수", ["\(viewStore.state.pokemon?.hatchCounter ?? 0)"])
            ], color: viewStore.state.variety?.types.first?.typeColor)
        }
        .padding()
    }
    
    /// 스탯 뷰
    private func statsView(viewStore: PokemonDetailsStore) -> some View {
        VStack {
            Text("종족값")
                .bold()
            HStack {
                let title = ["HP", "공격", "방어", "특공", "특방", "스피드", "합계"]
                let content = viewStore.state.variety?.stats.addSum ?? []
                
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
        .padding(.horizontal)
    }
    /// 계산기 버튼
    private func calculatorButton(viewStore: PokemonDetailsStore) -> some View {
        Button {
            viewStore.send(.view(.didTappedCalculatorButton))
        } label: {
            Text("종족값 계산")
                .shadow(radius: 1)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(viewStore.state.variety?.types.first?.typeColor)
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
    /// 특성 뷰
    @ViewBuilder
    private func passiveView(viewStore: PokemonDetailsStore) -> some View {
        KeyValueListView(
            title: "특성",
            description: "진한 글자로 표시된 특성은 숨겨진 특성입니다.",
            items: viewStore.state.variety?.abilites.items ?? [],
            color: viewStore.state.variety?.types.first?.typeColor
        )
    }
    /// 진화 트리
    private func eveolutionTreeView(viewStore: PokemonDetailsStore) -> some View {
        VStack {
            Text("진화")
                .bold()
                .padding(.top)
            IfLetStore(store.scope(
                state: \.evoltionTreeState,
                action: \.child.evoltionTreeAction)
            ) { store in
                EvolutionTreeNodeView(store: store)
            }
        }
    }
    /// 도감 설명 뷰
    @ViewBuilder
    private func descriptionView(viewStore: PokemonDetailsStore) -> some View {
        KeyValueListView(
            title: "도감 설명",
            items: viewStore.state.pokemon?.textEntries?.items ?? [],
            color: viewStore.state.variety?.types.first?.typeColor
        )
        .padding(.top)
    }
    /// 계산기 뷰
    private func calculatorView(calculatorStore: Store<CalculatorFeature.State, CalculatorFeature.Action>) -> some View {
        CalculateView(store: calculatorStore)
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let store = Store(initialState: PokemonDetailsFeature.State(id: 670)) { PokemonDetailsFeature() }
    PokemonDetailsView(store: store)
}

