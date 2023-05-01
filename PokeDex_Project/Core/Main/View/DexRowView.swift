//
//  DexRowView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/29.
//

import SwiftUI
import Kingfisher

struct DexRowView: View {
    let pokemonNum: Int
    @ObservedObject var vm = PokeDexViewModel()
    //@State var text = ""
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 200)
            .foregroundColor(.primary.opacity(0.1))
            .overlay(alignment: .top) {
                Text(vm.names)
                    .foregroundColor(.primary)
                    .bold()
                    .padding()
            }
            .overlay {
                BallImage()
                    .frame(width: 100, height: 100)
            }
            .overlay(content: {
                KFImage(URL(string:vm.imageUrl(url: pokemonNum)))
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
                        .foregroundColor(Color.typeColor(types: vm.types.first ?? ""))
                        .overlay {
                            Text(vm.types.first ?? "")
                                .shadow(color: .black, radius: 2)
                                .padding(.horizontal)
                                .padding(2)
                        }

                    if vm.types.count > 1 {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 65,height: 20)
                            .foregroundColor(Color.typeColor(types: vm.types.last ?? ""))
                            .overlay {
                                Text(vm.types.last ?? "")
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
            .task {
                let name = await vm.getKoreanName(num: pokemonNum)
                let type = await vm.getKoreanType(num: pokemonNum)
                DispatchQueue.main.async {
                    vm.names = name
                    vm.types = type
                }
            }
    }
}



struct DexRowView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            DexRowView(pokemonNum: 23)
            DexRowView(pokemonNum: 21)
        }
        .padding()
    }
}
