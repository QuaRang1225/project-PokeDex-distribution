//
//  MainView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/28.
//

import SwiftUI
import Kingfisher

struct MainView: View {
    
    let columns = [ GridItem(.flexible()), GridItem(.flexible())]
    @State var isSearch = false
    @State var text:String = ""
    @StateObject var vm = PokeDexViewModel()
    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            header
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(vm.dexNum,id:\.self){ item in
                        VStack(alignment: .leading,spacing: 0){
                            HStack(spacing: 0){
                                ball
                                Text(String(format: "%04d", item))
                                    .bold()
                            }
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height:200)
                                .foregroundColor(.primary.opacity(0.1))
                                .overlay(content: {
                                    KFImage(URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(item).png"))
                                        .resizable()
                                        .placeholder{
                                            ProgressView()
                                        }
                                        .frame(width: 120,height: 120)
                                        
                                })
                                .overlay(alignment:.bottomLeading) {
                                    Text("이상해씨")
                                        .bold()
                                        .padding()
                                }
                                .padding(.bottom,5)
                        }
                        
                    }
                }.padding(.horizontal).padding(.top)
            }
           
        }
        .onChange(of:vm.location){ newValue in
            Task{
                let dexNum = await vm.getLocation()
                DispatchQueue.main.async {
                    vm.dexNum = dexNum
                }
            }
        }
        .onTapGesture {
            isSearch = false
        }
    }
    var header:some View{
        VStack{
            HStack(spacing: 0){
                Menu {
                    Picker("", selection: $vm.location) {
                        ForEach(LocationFilter.allCases, id: \.self) {
                            Text($0.name)
                                .tag($0)
                           }
                         } .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                        .onChange(of: vm.location) { newValue in
                            vm.location = newValue
                        }
                } label: {
                    HStack{
                        Text(vm.location.name)
                            .font(.title)
                            .bold()
                        Image(systemName: "chevron.down")
                    }.foregroundColor(.primary)
                }
                Spacer()
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
            }
            if isSearch{
                SearchBarView(text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
            }
        }.padding(.horizontal,20)
            .padding(.bottom)
            .shadow(radius: 20)
        
    }
    var ball:some View{
        KFImage(URL(string: "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
