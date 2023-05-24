//
//  StartView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/05/02.
//

import SwiftUI

struct StartView: View {
    @State var count = 0
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @EnvironmentObject var vm:PokeDexViewModel
    var body: some View {
        ZStack{
            VStack{
                Image("logo")
                    .resizable()
                    .frame(width: 80,height: 80)
//                if vm.pokeDexCount != 1010{
////                    ProgressView("다운로드중...", value: Double(vm.pokeDexCount) / 1010, total: 1.0)
////                        .padding()
//                    Text("\(vm.pokeDexCount)")
//
//
//                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(PokeDexViewModel())
    }
}
