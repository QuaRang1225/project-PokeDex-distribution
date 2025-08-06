//
//  VisibleModifier.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/22/25.
//

import Foundation
import SwiftUI

/// 컴포넌트가 보일 때 실행될 첨자
struct VisibleModifier: ViewModifier {
    let action: () -> Void
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.frame(in: .global).minY) { _ in
                            let screenHeight = UIScreen.main.bounds.height
                            let frame = proxy.frame(in: .global)
                            
                            if !hasAppeared && frame.maxY > 0 && frame.minY < screenHeight {
                                hasAppeared = true
                                action()
                            }
                        }
                }
            )
    }
}
