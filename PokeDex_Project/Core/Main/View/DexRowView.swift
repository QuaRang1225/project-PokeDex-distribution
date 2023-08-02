//
//  DexRowView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/29.
//

import SwiftUI
import Kingfisher

struct DexRowView: View {
    let row: Row
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 200)
            .foregroundColor(.primary.opacity(0.1))
            .overlay(alignment: .top) {
                Text(row.name)
                    .foregroundColor(.primary)
                    .bold()
                    .padding()
            }
            .overlay {
                BallImage()
                    .frame(width: 100, height: 100)
            }
            .overlay(content: {
                KFImage(URL(string:row.image))
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .frame(width: 120, height: 120)
            })
            .overlay(alignment:.bottom) {
                HStack {
                    TypeComponentView(type: row.types.first!)

                    if row.types.count > 1 {
                        TypeComponentView(type: row.types.last!)
                    }
                }
                .padding(.bottom, 5)
            }

    }
}



struct DexRowView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            DexRowView(row:Row(dexNum: 1, num: 1, image: "", name: "이상해씨", types: ["풀","독"]))
        }
        .padding()
    }
}
