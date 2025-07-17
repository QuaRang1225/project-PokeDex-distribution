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
    
    @State var start = false
    let store = Store(initialState: TabBarFeature.State()) { TabBarFeature() }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ZStack{
                    if start{
                        TabBarView(store: store)
                    }else{
                        StartView()
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 1.0)){
                        start = true
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
