//
//  SearchBoardView.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/18/25.
//

import SwiftUI
import ComposableArchitecture

/// 검색 보드 View
struct SearchBoardView: View {
    typealias SearchBoardStore = ViewStoreOf<SearchBoardFeature>
    let store: StoreOf<SearchBoardFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    filterLabel(viewStore: viewStore)
                    Spacer()
                    resetButton(viewStore: viewStore)
                }
                .padding(.top, 30)
                searchBar(viewStore: viewStore)
                typesBar(viewStore: viewStore)
                Divider().padding()
                typesList(viewStore: viewStore)
                Spacer()
                searchButton(viewStore: viewStore)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

// MARK: - 검색 보드 뷰 컴포넌트 정의
extension SearchBoardView {
    /// 필터 라벨
    private func filterLabel(viewStore: SearchBoardStore) -> some View {
        Text("필터")
            .font(.title3)
            .fontWeight(.bold)
            .padding(.horizontal)
    }
    /// 초기화 버튼
    private func resetButton(viewStore: SearchBoardStore) -> some View {
        Button {
            viewStore.send(.didTappedResetButton)
        } label: {
            Label(
                title: { Text("초기화") },
                icon: { Image(systemName: "arrow.clockwise") }
            )
            .foregroundStyle(.blue)
        }
        .padding(.horizontal)
    }
    /// 검색바
    private func searchBar(viewStore: SearchBoardStore) -> some View {
        SearchBar(
            text: viewStore.binding(
                get: \.query,
                send: { .didChangeQuery($0) }
            )
        )
    }
    /// 타입 검색 바
    @ViewBuilder
    private func typesBar(viewStore: SearchBoardStore) -> some View {
        let width = UIScreen.main.bounds.width/4 - 15
        HStack {
            Text("타입:")
                .bold()
            Spacer()
            ForEach(viewStore.state.types, id: \.self) { type in
                Button {
                    viewStore.send(.didTappedTypeButton(type))
                } label: {
                    TypesView(type: type, width: width, height: 25, font: .body)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    /// 타입 리스트
    @ViewBuilder
    private func typesList(viewStore: SearchBoardStore) -> some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 4)
        LazyVGrid(columns: columns) {
            ForEach(TypeFilter.allCases, id: \.self) { type in
                Button {
                    viewStore.send(.didTappedTypeListCell(type.rawValue))
                } label: {
                    TypesView(type: type.rawValue, height: 25, font: .body)
                }
            }
        }
        .padding(.horizontal)
    }
    /// 검색 버튼
    private func searchButton(viewStore: SearchBoardStore) -> some View {
        Button {
            viewStore.send(.delegate(.didTappedSearchButton))
        } label: {
            Text("검색")
                .bold()
                .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                .foregroundStyle(.white)
                .background(.pink)
        }
    }
}

#Preview {
    let store = Store(initialState: SearchBoardFeature.State()) { SearchBoardFeature() }
    SearchBoardView(store: store)
}



