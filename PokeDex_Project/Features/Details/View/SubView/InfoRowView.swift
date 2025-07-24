//
//  InfoRowView.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/22/25.
//

import SwiftUI

/// 포켓몬의 각각의 정보를 표현할 셀
struct InfoRowView: View {
    /// 타이틀, 내용
    let items: [(String, [String])]
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            ForEach(items, id: \.0) { title, contents in
                VStack(spacing: 10) {
                    titleLabel(title)
                    VStack(spacing: 4) {
                        Spacer()
                        ForEach(contents, id: \.self) { content in
                            contentLabel(content)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground).opacity(0.5))
                }
                .background(color.opacity(0.2))
                .cornerRadius(8)
            }
        }
    }
}

// MARK: - 포켓몬 정보 뷰 컴포넌트 정의
extension InfoRowView {
    /// 타이틀 라벨
    private func titleLabel(_ title: String) -> some View {
        Text(title)
            .bold()
            .padding(.top, 10)
    }
    /// 내용 라벨
    private func contentLabel(_ content: String) -> some View {
        Text(content)
            .font(.subheadline)
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    InfoRowView(items: [
        ("분류", ["풍선포켓몬"]),
        ("키", ["1.0m"]),
        ("무게", ["12.0kg"]),
        ("포획률", ["50"])
    ], color: "독".typeColor)
    .frame(height: 50)
}
