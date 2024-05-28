//
//  BallImage.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import SwiftUI
struct BallImageView: View {
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.gray.opacity(0.1))
                .overlay {
                    Rectangle()
                        .frame(height: 20)
                        .foregroundColor(Color.typeColor("antiPrimary"))
                    Circle()
                        .foregroundColor(Color.typeColor("antiPrimary"))
                        .frame(width: 60,height: 60)
                }
           
        }
    }
}
#Preview {
    BallImageView()
}
