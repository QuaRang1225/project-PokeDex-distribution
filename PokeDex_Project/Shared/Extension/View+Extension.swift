//
//  View+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/22/25.
//

import Foundation
import SwiftUI

/// View 관련 확장사항
extension View {
    /// 컴포넌트가 등장할 떄마다 실행
    func onVisible(_ action: @escaping () -> Void) -> some View {
        self.modifier(VisibleModifier(action: action))
    }
    /// 컴포넌트가 한번 등장하면 메모리에서 사라지기 전까지는 실행 안됨
    func onDidLoad(_ action: @escaping () -> Void) -> some View {
        self.modifier(DidLoadModifier(action: action))
    }
}
