//
//  PokeDex_ProjectApp.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/21.
//

import SwiftUI

@main
struct PokeDex_ProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
//                TestView()
            }
        }
    }
}
