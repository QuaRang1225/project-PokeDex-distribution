//
//  DidLoadModifier.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/22/25.
//

import Foundation
import SwiftUI

/// 컴포넌트가 한번 로딩 되면 실행 안되게 이벤트를 실행할 첨자
struct DidLoadModifier: ViewModifier {
    let action: () -> Void
    @State private var isLoaded = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !self.isLoaded {
                    self.action()
                    self.isLoaded = true
                }
            }
    }
}
