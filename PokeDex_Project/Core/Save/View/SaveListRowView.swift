//
//  SaveListRow.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/06/20.
//

import SwiftUI
import Kingfisher

struct SaveListRowView: View {
    let row:Save
    var body: some View {
        HStack{
            KFImage(URL(string: row.image))
                .resizable()
                .frame(width: 50, height: 50)
            
            Text(row.name)
            Spacer()
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 85,height: 25)
                    .foregroundColor(Color.typeColor(types: row.types.first ?? ""))
                    .overlay {
                        Text(row.types.first ?? "")
                            .shadow(color: .black, radius: 2)
                            .padding(.horizontal)
                            .padding(2)
                    }

                if row.types.count > 1 {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 85,height: 25)
                        .foregroundColor(Color.typeColor(types: row.types.last ?? ""))
                        .overlay {
                            Text(row.types.last ?? "")
                                .shadow(color: .black, radius: 2)
                                .padding(.horizontal)
                                .padding(2)
                        }
                }
            }
        }
    }
}

//struct SaveListRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaveListRowView(row: Row(dexNum: 1, num: 1, image: "", name: "이상해씨", type: ["풀","독"]))
//
//    }
//}
