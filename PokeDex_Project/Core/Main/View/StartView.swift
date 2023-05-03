//
//  StartView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/05/02.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack{
            Image("logo")
                .resizable()
                .frame(width: 80,height: 80)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
