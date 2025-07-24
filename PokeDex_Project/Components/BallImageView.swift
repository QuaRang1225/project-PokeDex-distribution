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
                        .foregroundColor(.systemBackground)
                    Circle()
                        .foregroundColor(.systemBackground)
                        .frame(width: 60,height: 60)
                }
           
        }
    }
}
#Preview {
    BallImageView()
}
