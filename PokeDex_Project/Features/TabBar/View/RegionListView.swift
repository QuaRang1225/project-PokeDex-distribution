//
//  RegionListView.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/18/25.
//

import SwiftUI
import ComposableArchitecture

/// 지역 리스트 선택 뷰
struct RegionListView: View {
    
    typealias RegionListStore = ViewStoreOf<RegionListFeature>
    let store: StoreOf<RegionListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .topLeading) {
                Color.clear
                    .background(Material.regular)
                VStack(spacing: 0) {
                    VStack {
                        titleLabel
                        subscriptLabel
                    }
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10) {
                            regionListView(viewStore: viewStore)
                        }
                        .padding(.vertical, 30)
                    }
                }
                dismissButton(viewStore: viewStore)
            }
        }
    }
}

// MARK: - 지역 리스트 선택 뷰 컴포넌트 정의
extension RegionListView {
    var titleLabel: some View {
        Text("도감 선택")
            .font(.title)
            .fontWeight(.semibold)
    }
    var subscriptLabel: some View {
        Text("지방에 따른 도감을 선택해주세요")
            .font(.body)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
    }
    /// 지역 리스트 뷰
    func regionListView(viewStore: RegionListStore) -> some View {
        ForEach(RegionFilter.allCases, id: \.self) { region in
            Button {
                viewStore.send(.didTapRegion(region))
            } label: {
                Text(region.rawValue)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.primary)
        }
    }
    /// 닫기 버튼
    func dismissButton(viewStore: RegionListStore) -> some View {
        Button {
            viewStore.send(.didTappedDismissButton)
        } label: {
            Image(systemName: "xmark")
                .font(.title2)
        }
        .foregroundStyle(.primary)
        .padding(.top, 5)
        .padding(.leading)
    }
}

#Preview {
    let store = Store(initialState: RegionListFeature.State()) { RegionListFeature() }
    RegionListView(store: store)
}
