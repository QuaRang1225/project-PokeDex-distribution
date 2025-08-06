//
//  EvolTreeNodeView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

/// 진화 트리 노드 뷰
struct EvolutionTreeNodeView: View {
    typealias EvolutionTreeStore = ViewStoreOf<EvolutionTreeFeature>
    let store: StoreOf<EvolutionTreeFeature>
    
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                imageButton(viewStore: viewStore)
                chevrongImageView(viewStore: viewStore)
                nextPokemon(viewStore: viewStore)
            }
            .onDidLoad {
                viewStore.send(.viewDidLoad)
            }
        }
    }
}

// MARK: - 지놔 트리 노드 뷰 컴포넌트 정의
extension EvolutionTreeNodeView {
    /// 이미지 버튼
    private func imageButton(viewStore: EvolutionTreeStore) -> some View {
        Button {
            viewStore.send(.didTappedEvolutionTo)
        } label: {
            VStack {
                HStack {
                    ForEach(viewStore.state.node.image, id: \.self){ image in
                        KFImage(URL(string: image))
                            .placeholder{
                                Color.gray.opacity(0.2)
                            }
                            .resizable()
                            .frame(width: 70,height: 70)
                            .cornerRadius(10)
                    }
                }
                Text(viewStore.state.node.name).bold().font(.caption)
            }
            .foregroundColor(.primary)
        }
    }
    /// 화살표 버튼
    @ViewBuilder
    private func chevrongImageView(viewStore: EvolutionTreeStore) -> some View {
        if !viewStore.state.node.evolTo.isEmpty {
            Image(systemName: "chevron.down")
                .font(.title2)
                .padding(.vertical,10)
        }
    }
    /// 진화트리 재귀 뷰
    @ViewBuilder
    private func nextPokemon(viewStore: EvolutionTreeStore) -> some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 3)
        HStack(alignment: .top) {
            ForEachStore(
                store.scope(state: \.children, action: \.children)
            ) { childStore in
                EvolutionTreeNodeView(store: childStore)
            }
            .lazyVGrid(columns: columns, condition: viewStore.node.evolTo.count > 3)
        }
    }
}

#Preview {
    let store = Store(
        initialState: EvolutionTreeFeature.State(
            node: CustomData.instance.evolutionTree
        )) {
        EvolutionTreeFeature()
        }
    EvolutionTreeNodeView(store: store)
}
