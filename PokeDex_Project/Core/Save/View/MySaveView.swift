//
//  MySaveVuew.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/06/20.
//

import SwiftUI
import Kingfisher





struct MySaveView: View {
    
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var isSearch = false
    @State var text:String = ""
    @State var delete = false
    @EnvironmentObject var vm:SaveViewModel
    @Environment(\.dismiss) var dismiss
//    @StateObject var vm = SaveViewModel()
    
    var filteredItems: [Save] {
        if text.isEmpty {
            return vm.save
        } else {
            return vm.save.filter { String($0.name).contains(text) || String($0.num).contains(text)}
        }
    }
    var body: some View {
        NavigationView {
            ZStack{
                VStack(alignment: .leading,spacing: 0){
                    Section(header: header){
                        ScrollView{
                                ForEach(filteredItems){ item in //id삭제하니까 됨;;;;;;;;;;;;;
                                    VStack(alignment: .leading,spacing: 0){
                                        HStack(spacing: 0){
                                            ball
                                            Text(String(format: "%04d",item.num))
                                                .bold()
                                        }
                                        HStack{
                                            NavigationLink {
                                                PokemonInfoView(num: item.num)
                                                    .environmentObject(vm)
                                                    .navigationBarBackButtonHidden()
                                            } label: {
                                                SaveListRowView(row: item)
                                            }
                                            .padding(.bottom,5)
                                            if delete{
                                                Button {
                                                    vm.deleteData(save: item)
//                                                    MySave.delMemo(item)
                                                } label: {
                                                    Image(systemName: "xmark")
                                                        .foregroundColor(.white)
                                                        .padding()
                                                        .ignoresSafeArea()
                                                }
                                            }
                                        }
                                    }
                                    Divider()
                                }.padding(.horizontal).padding(.vertical)
                                .padding(.bottom,70)
                        }
                    }
                }
            }
            .foregroundColor(.primary)
            .ignoresSafeArea()
            .onTapGesture{
                UIApplication.shared.endEditing()
            }
        }
    }
}


struct MySaveView_Previews: PreviewProvider {
    static var previews: some View {
        MySaveView()
            .environmentObject(SaveViewModel())
    }
}



extension MySaveView{
    var header:some View{
        VStack{
            HStack(spacing: 0){
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                        .padding(.trailing,10)
                }

                
                Text("내 포켓몬")
                    .font(.title)
                    .bold()
                Spacer()
                Button {
                    withAnimation(.linear(duration: 0.1)){
                        delete.toggle()
                    }
                } label: {
                    Image(systemName: "trash")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.primary)
                }.padding(.trailing)

                Button {
                    withAnimation(.linear(duration: 0.1)){
                        isSearch.toggle()
                    }
                } label: {
                    Image(systemName:"magnifyingglass")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }.padding(.top,50)
            if isSearch{
                SearchBarView(text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.top)
            }
        }.padding(.horizontal,20)
            .padding(.bottom)
            .shadow(radius: 20)
        
    }
    var ball:some View{
        KFImage(URL(string: "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"))
    }
}
