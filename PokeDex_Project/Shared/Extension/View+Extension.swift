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
    /// 패드 여부 - 미니는 패드가 아닌 것으로 분류함
    var isIpad: Bool {
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            return false
        }
        
        let nativeBounds = UIScreen.main.nativeBounds
        let nativeWidth = nativeBounds.width
        let nativeHeight = nativeBounds.height
        
        // iPad mini 4, 5: 1536 x 2048
        // iPad mini 6: 1488 x 2266
        if (nativeWidth == 1536 && nativeHeight == 2048) || (nativeWidth == 2048 && nativeHeight == 1536) {
            return false // iPad mini 4, 5
        } else if (nativeWidth == 1488 && nativeHeight == 2266) || (nativeWidth == 2266 && nativeHeight == 1488) {
            return false // iPad mini 6
        }

        return true
    }
}
