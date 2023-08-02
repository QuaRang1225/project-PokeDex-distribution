//
//  TypeComponentView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/08/02.
//

import SwiftUI

struct TypeComponentView: View {
    let type:String
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 65,height: 20)
            .foregroundColor(Color.typeColor(types: type))
            .overlay {
                Text(type)
                    .shadow(color: .black, radius: 2)
                    .padding(.horizontal)
                    .padding(2)
            }
            .font(.caption2)
            .bold()
            .foregroundColor(.white)
    }
}

struct TypeComponentView_Previews: PreviewProvider {
    static var previews: some View {
        TypeComponentView(type:"비행")
    }
}
