//
//  KeyValueListView.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/22/25.
//

import SwiftUI

/// 키-값 리스트 - 도감 설명 or 특성 설명
struct KeyValueListView: View {
    let title: String
    var description: String? = nil
    var items: [(String, String, Bool?)] = []
    
    var body: some View {
        VStack(spacing: 10) {
            titleLabel
            descriptionLabel
            VStack(spacing: 0) {
                ForEach(items, id: \.0) { key, value, isHighlighted in
                    listCell(key: key, value: value, isHighlighted: isHighlighted)
                    Divider()
                        .background(Color.gray.opacity(0.5).frame(height: 1))
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

// MARK: - 키-값 리스트 뷰 컴포넌트 정의
extension KeyValueListView {
    /// 제목 라벨
    private var titleLabel: some View {
        Text(title)
            .bold()
            .padding(.top)
    }
    /// 설명 라벨
    @ViewBuilder
    private var descriptionLabel: some View {
        if let description {
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    /// 리스트 셀
    private func listCell(key: String, value: String, isHighlighted: Bool? = nil) -> some View {
        HStack {
            Text(key)
                .font(.subheadline)
                .fontWeight((isHighlighted ?? false) ? .heavy : .medium)
                .frame(width: 120)
                .frame(maxHeight: .infinity)
                .padding(.vertical, 20)
                .background(CustomData.instance.pokemon.color.map { Color($0).opacity(0.2) })
            HStack {
                Text(value)
                    .font(.subheadline)
                    .padding(.vertical)
                    .padding(.horizontal, 5)
                Spacer()
            }
        }
    }
}


#Preview {
    KeyValueListView(
        title: "리스트",
        description: "리스트입니다만;;",
        items: Array(repeating: ("x", "x입니다만", nil), count: 10)
    )
}
