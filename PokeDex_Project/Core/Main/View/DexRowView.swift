//
//  DexRowView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/29.
//

import SwiftUI
import Kingfisher

struct DexRowView: View {
    let row: PokeDex
    
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
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 65,height: 20)
                        .foregroundColor(Color.typeColor(types: row.types.first ?? ""))
                        .overlay {
                            Text(row.types.first ?? "")
                                .shadow(color: .black, radius: 2)
                                .padding(.horizontal)
                                .padding(2)
                        }

                    if row.types.count > 1 {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 65,height: 20)
                            .foregroundColor(Color.typeColor(types: row.types.last ?? ""))
                            .overlay {
                                Text(row.types.last ?? "")
                                    .shadow(color: .black, radius: 2)
                                    .padding(.horizontal)
                                    .padding(2)
                            }
                    }
                }
                .font(.caption2)
                .bold()
                .foregroundColor(.white)
                .padding(.bottom, 5)
            }

    }
}



struct DexRowView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            DexRowView(row: PokeDex())
            //(num: 1, image: "", name: "이상해씨", type: ["풀","독"])
        }
        .padding()
    }
}
