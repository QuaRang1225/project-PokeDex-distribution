//
//  EvolTreeNodeView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import SwiftUI
import Kingfisher

struct EvolTreeNodeView: View {
    let items = Array(repeating: GridItem(.flexible()), count: 3)
    let node: EvolutionTo?
    
    var body: some View {
        VStack {
            Button {
                
            } label: {
                VStack {
                    HStack {
                        ForEach(node?.image ?? [], id: \.self){ image in
                            KFImage(URL(string: image))
                                .placeholder{
                                    Color.gray.opacity(0.2)
                                }
                                .resizable()
                                .frame(width: 70,height: 70)
                                .cornerRadius(10)
                            
                        }
                    }
                    Text(node?.name ?? "").bold().font(.caption)
                }
                .foregroundColor(.primary)
            }
            if let evolTo = node?.evolTo, !evolTo.isEmpty {
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .padding(.vertical,10)
            }
            HStack (alignment: .top){
                if let evolTo = node?.evolTo, evolTo.count > 3{
                    LazyVGrid(columns: items){
                        ForEach(evolTo,id: \.self) { child in
                            EvolTreeNodeView(node: child)
                                .padding()
                        }
                    }
                }else{
                    ForEach(node?.evolTo ?? [],id: \.self) { child in
                        EvolTreeNodeView(node: child)
                    }
                }
            }
        }
    }
}

#Preview {
    EvolTreeNodeView(node: CustomData.instance.evolutionTree)
}
