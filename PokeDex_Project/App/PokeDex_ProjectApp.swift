//
//  PokeDex_ProjectApp.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/21.
//

import SwiftUI
import ComposableArchitecture

@main
struct PokeDex_ProjectApp: App {
    
    @State var start = true
    @State var topOffset: CGFloat = -25
    @State var bottomOffset: CGFloat = 25
    @State var gradientOpacity: Double = 1.0
    
    let store = Store(initialState: TabBarFeature.State()) { TabBarFeature() }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ZStack{
                    TabBarView(store: store)
                    if start {
                        SplashView(
                            topOffset: $topOffset,
                            bottomOffset: $bottomOffset,
                            gradientOpacity: $gradientOpacity
                        )
                        .onAppear {
                            // 1초 후 애니메이션 시작
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    topOffset = -500
                                    bottomOffset = 500
                                    gradientOpacity = 0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        start = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
