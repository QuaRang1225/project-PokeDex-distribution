//
//  SearchBar.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/22/25.
//

import Foundation
import SwiftUI

/// 검색바 구현
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            imageView
            texField
            Spacer()
            clearButton
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}

// MARK: - 검색바 컴포넌트
extension SearchBar {
    /// 돋보기 이미지
    private var imageView: some View {
        Image(systemName: "magnifyingglass")
            .foregroundStyle(.gray)
    }
    /// 텍스트 필드
    private var texField: some View {
        TextField("포켓몬 이름", text: $text)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
    }
    /// 삭제 버튼
    @ViewBuilder
    private var clearButton: some View {
        if !text.isEmpty {
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
