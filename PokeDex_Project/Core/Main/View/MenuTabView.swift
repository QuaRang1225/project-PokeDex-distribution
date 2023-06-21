//
//  MenuTabView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/06/20.
//

import SwiftUI

struct MenuTabView: View {
    
    @State var mode = ""
    @EnvironmentObject var vmSave:SaveViewModel
    @EnvironmentObject var vm:PokeDexViewModel
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.antiPrimary)
    }
    
    var body: some View {
        TabView{
            MainView()
                .environmentObject(vm)
                .environmentObject(vmSave)
                .tabItem {
                    Image(systemName: "house.fill")
                }
            MySaveView()
                .environmentObject(vmSave)
                .tabItem {
                    Image(systemName: "star.fill")
                }
            
        }.accentColor(Color.primary)
    }
}

struct MenuTabView_Previews: PreviewProvider {
    static var previews: some View {
        MenuTabView()
            .environmentObject(PokeDexViewModel())
            .environmentObject(SaveViewModel())
    }
}
