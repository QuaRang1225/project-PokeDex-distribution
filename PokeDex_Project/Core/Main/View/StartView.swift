//
//  StartView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/05/02.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var vm:PokeDexViewModel
    var body: some View {
        ZStack{
            VStack{
                Image("logo")
                    .resizable()
                    .frame(width: 80,height: 80)
                if !UserDefaults.standard.bool(forKey: "ver 1.0.0"){
                    CircleProgressView().padding(.top,100)
                }
            }
//            Text("버전 1.0.0").frame(maxWidth: .infinity,alignment: .trailing)
//                .frame(maxHeight: .infinity,alignment: .bottom)
//                .padding()
//                .font(.caption)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(PokeDexViewModel())
    }
}
