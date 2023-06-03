//
//  SearchBarView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/28.
//

import SwiftUI

struct SearchBarView: View {
        
        @Binding var text:String
        
        
        var body: some View {
            HStack{
                Image(systemName: "magnifyingglass").bold()
                TextField("", text: $text)
                    .bold()
                    .background(alignment:.leading){
                        Text("포켓몬 이름이나 도감 번호를 입력해 주세요 ..").foregroundColor(.primary.opacity(text != "" ? 0.0:0.8))
                    }
                if text != ""{
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }.foregroundColor(.primary)
                
            
        }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(""))
    }
}
