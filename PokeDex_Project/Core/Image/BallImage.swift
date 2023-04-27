//
//  BallImage.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/27.
//

import SwiftUI

struct BallImage: View {
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.gray.opacity(0.1))
                .overlay {
                    Rectangle()
                        .frame(height: 20)
                        .foregroundColor(.white)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 60,height: 60)
                }
           
        }
    }
}

struct BallImage_Previews: PreviewProvider {
    static var previews: some View {
        BallImage()
    }
}
