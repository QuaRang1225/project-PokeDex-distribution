//
//  PokeDex_ProjectApp.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/21.
//

import SwiftUI
import Firebase


@main
struct PokeDex_ProjectApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
                
            }
        }
    }
}
