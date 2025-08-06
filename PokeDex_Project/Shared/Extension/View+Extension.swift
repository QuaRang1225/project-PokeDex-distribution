//
//  View+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/22/25.
//

import Foundation
import SwiftUI

// MARK: - View
extension View {
    /// 컴포넌트가 등장할 떄마다 실행
    func onVisible(_ action: @escaping () -> Void) -> some View {
        self.modifier(VisibleModifier(action: action))
    }
    /// 컴포넌트가 한번 등장하면 메모리에서 사라지기 전까지는 실행 안됨
    func onDidLoad(_ action: @escaping () -> Void) -> some View {
        self.modifier(DidLoadModifier(action: action))
    }
    /// 조건에 따라 LazyVGrid 반환
    @ViewBuilder
    func lazyVGrid(columns: [GridItem], condition: Bool = true) -> some View{
        if condition {
            LazyVGrid(columns: columns) {
                self
            }
        } else {
            self
        }
    }
    /// 뒷 배경 테투리
    func borderSection(title: String) -> some View {
        self
            .overlay(alignment: .topLeading) {
                Text(title)
                    .foregroundStyle(.pink)
                    .font(.caption)
                    .padding(.horizontal, 5)
                    .background(.background)
                    .fontWeight(.black)
                    .offset(x: 19, y: -8)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray)
            )
    }
    /// 키보드 내리기
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    /// 패드 여부
    var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
