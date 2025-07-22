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
                HStack {
                    dismissButton(viewStore: viewStore)
                    Spacer()
                    heartButton(viewStore: viewStore)
                }
                .padding(.horizontal)
                .overlay {
                    titleLabel(viewStore: viewStore)
                }
                adMobsView
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        previousPokemonButton(viewStore: viewStore)
                        pokemonImageView(viewStore: viewStore)
                        nextPokemonButton(viewStore: viewStore)
                    }
                    typesView(viewStore: viewStore)
                    pokemonInfoView(viewStore: viewStore)
                    statsView(viewStore: viewStore)
                    calculatorButton(viewStore: viewStore)
                    passiveView(viewStore: viewStore)
                    eveolutionTreeView(viewStore: viewStore)
                    descroptionView(viewStore: viewStore)
                }
            }
        }
    }
}

// MARK: - 포켓몬 상세화면 컴포넌트 정의
extension PokemonDetailsView {
    /// 헤더 뷰
    private func dismissButton(viewStore: PokemonDetailsStore) -> some View {
        Button {
            
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "chevron.left")
                Label {
                    Text("0040")
                } icon: {
                    KFImage(URL(string: String.mosterBallImageURL))
                }
            }
        }
        .foregroundStyle(.primary)
    }
    /// 포켓몬 이름
    private func titleLabel(viewStore: PokemonDetailsStore) -> some View {
        Text("푸크린")
            .bold()
    }
    /// 하트 버튼
    private func heartButton(viewStore: PokemonDetailsStore) -> some View {
        Button {
            
        } label: {
            Image(systemName: "heart")
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
                        .foregroundColor(Color.typeColor("antiPrimary"))
                    Circle()
                        .foregroundColor(Color.typeColor("antiPrimary"))
                        .frame(width: 60,height: 60)
                }
            KFImage(URL(string: CustomData.instance.pokemon.base?.image ?? ""))
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
            
        } label: {
            Image(systemName: "chevron.backward.circle.fill")
                .font(.title)
                .foregroundStyle(.gray)
        }
    }
    /// 다음 포켓몬 이동 버튼
    private func nextPokemonButton(viewStore: PokemonDetailsStore) -> some View {
        Button {
            
        } label: {
            Image(systemName: "chevron.right.circle.fill")
                .font(.title)
                .foregroundStyle(.gray)
        }
    }
    /// 타입 뷰
    private func typesView(viewStore: PokemonDetailsStore) -> some View {
        HStack(spacing: 8) {
            ForEach(CustomData.instance.pokemon.base?.types ?? [], id:\.self) { type in
                TypesView(type: type, width: 100, height: 30, font: .body)
            }
        }
    }
    /// 포켓몬 정보 뷰
    private func pokemonInfoView(viewStore: PokemonDetailsStore) -> some View {
        VStack(spacing: 30) {
            InfoRowView(items: [
                ("분류", ["풍선포켓몬"]),
                ("키", ["1.0m"]),
                ("무게", ["12.0kg"]),
                ("포획률", ["50"])
            ])
            
            InfoRowView(items: [
                ("알그룹", ["요정"]),
                ("성비", ["암컷: 100%", "수컷: 0%"]),
                ("부화", ["70"])
            ])
        }
        .padding()
    }
    
    /// 스탯 뷰
    private func statsView(viewStore: PokemonDetailsStore) -> some View {
        VStack {
            Text("종족값")
                .bold()
            HStack {
                let stats = ["HP", "공격", "방어", "특공", "특방", "스피드"]
                let statsValue = [100, 50, 200, 150, 100, 10]
                ForEach(Array(zip(stats, statsValue)), id: \.0) { title, content in
                    VStack(spacing: 5) {
                        Text(title)
                            .bold()
                        Text("\(content)")
                            .foregroundStyle(content >= 150 ? .red : .primary)
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
            
        } label: {
            Text("종족값 계산")
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(CustomData.instance.pokemon.color.map { Color($0) })
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
    /// 특성 뷰
    @ViewBuilder
    private func passiveView(viewStore: PokemonDetailsStore) -> some View {
        let passive = [
            ("헤롱헤롱바디", "이 포켓몬과 성별이 다른 포켓몬이 이 포켓몬을 상대로 접촉 기술을 사용하면 30% 확률로 헤롱헤롱 상태에 빠지게 된다.", false),
            ("승기", "능력치가 하락하면 특수공격이 2랭크 상승한다.", false),
            ("통찰", "상대 포켓몬이 지닌 도구를 알 수 있다.", true)
        ]
        KeyValueListView(
            title: "특성",
            description: "진한 글자로 표시된 특성은 숨겨진 특성입니다.",
            items: passive
        )
    }
    /// 진화 트리
    private func eveolutionTreeView(viewStore: PokemonDetailsStore) -> some View {
        VStack {
            Text("진화")
                .bold()
                .padding(.top)
            EvolTreeNodeView(node: CustomData.instance.evolutionTree)
        }
    }
    /// 도감 설명 뷰
    @ViewBuilder
    private func descroptionView(viewStore: PokemonDetailsStore) -> some View {
        let types: [(title: String, content: String)] = zip(
            CustomData.instance.pokemon.textEntries?.version ?? [],
            CustomData.instance.pokemon.textEntries?.text ?? []
        ).map { ($0, $1) }
        
        let converted = types.map { ($0.title, $0.content, nil as Bool?) }
        KeyValueListView(
            title: "도감 설명",
            items: converted
        )
        .padding(.top)
    }
}

#Preview {
    let store = Store(initialState: PokemonDetailsFeature.State()) { PokemonDetailsFeature() }
    PokemonDetailsView(store: store)
}

