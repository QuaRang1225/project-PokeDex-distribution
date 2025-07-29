//
//  StartView.swift
//  PokeDex_Project
//
//  Created by Quarang on 5/20/25.
//

import SwiftUI

/// 스플래시 뷰
struct SplashView: View {
    @Binding var topOffset: CGFloat
    @Binding var bottomOffset: CGFloat
    @Binding var gradientOpacity: Double
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            backgroundView
            VStack {
                topImageView
                Spacer()
                bottomImageView
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - 스플래시 뷰 컴포넌트 정의
extension SplashView {
    /// 배경 뷰
    var backgroundView: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.cyan.opacity(0.5),
                    Color.white,
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .opacity(gradientOpacity)
    }
    /// 상단 이미지 뷰
    var topImageView: some View {
        Image("top")
            .resizable()
            .offset(y: topOffset)
    }
    /// 하단 이미지 뷰
    var bottomImageView: some View {
        Image("bottom")
            .resizable()
            .offset(y: bottomOffset)
    }
}

#Preview {
    SplashView(
        topOffset: .constant(0),
        bottomOffset: .constant(0),
        gradientOpacity: .constant(1.0)
    )
}
