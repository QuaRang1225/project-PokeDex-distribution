//
//  TypesView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import SwiftUI

/// 타입 뷰
struct TypesView: View {
    let type: String
    var width: CGFloat? = .infinity
    let height: CGFloat
    let font: Font
    
    var body: some View {
        Capsule()
            .frame(height: height)
            .frame(maxWidth: width)
            .foregroundColor(type.typeColor)
            .overlay {
                Text(type)
                    .font(font)
                    .padding(.horizontal, 5)
                    .foregroundColor(.white)
                    .shadow(color:.black, radius: 0.5)
            }
    }
}

#Preview {
    TypesView(type: "불꽃", width: 150, height: 32, font: .body)
}
