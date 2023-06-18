//
//  MainView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/28.
//

import SwiftUI
import Kingfisher
import RealmSwift
import PokemonAPI

struct MainView: View {
    
    let columns = [ GridItem(.flexible()), GridItem(.flexible())]
    @State var isSearch = false
    @State var text:String = ""
    @State var selectLocation = false
    @State var dexName = "전국도감"
    @State var dex:[Int] = []
    
    @EnvironmentObject var vm:PokeDexViewModel
    
    var filteredItems: [Row] {
        if text.isEmpty {
            return vm.array
        } else {
            return vm.array.filter { String($0.name).contains(text) || String($0.num).contains(text)}
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack(alignment: .leading,spacing: 0){
                    header
                    ScrollView{
                        LazyVGrid(columns: columns) {
                            ForEach(filteredItems,id:\.self){ item in
                                VStack(alignment: .leading,spacing: 0){
                                    HStack(spacing: 0){
                                        ball
                                        Text(String(format: "%04d",item.num))
                                            .bold()
                                    }
                                    NavigationLink {
                                        PokemonInfoView(num: item.dexNum)
                                            .navigationBarBackButtonHidden()
                                    } label: {
                                        DexRowView(row: item)
                                    }
                                    .padding(.bottom,5)
                                }
                            }

                        }.padding(.horizontal).padding(.top)
                    }.refreshable {
                        vm.dexNum()
                    }
                }
                if selectLocation{
                    Color.clear.ignoresSafeArea()
                        .background(.regularMaterial)
                    VStack(spacing:20){
                        ScrollView(showsIndicators: false){
                            Spacer()
                            ForEach(LocationFilter.allCases,id:\.self){ loc in
                                Button {
                                    dexName = loc.name
                                    vm.location = loc
                                    selectLocation = false
                                } label: {
                                    Text(loc.name)
                                        .bold()
                                        .foregroundColor(.primary)
                                }.padding(.vertical,10)
                                
                            }.padding(.bottom)
                            Button {
                                selectLocation = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.primary)
                                    .font(.largeTitle)
                            }
                        }
                    }
                }
            }
            .onAppear{
                vm.dexNum()
            }
            .onChange(of: vm.location) { _ in
                vm.dexNum()
            }
            .onTapGesture{
                UIApplication.shared.endEditing()
            }
        }
    }
    var header:some View{
        VStack{
            HStack(spacing: 0){
                Button {
                    selectLocation = true
                } label: {
                    Text(dexName)
                        .font(.title)
                        .bold()
                       
                    Image(systemName: "chevron.down")
                }
                .foregroundColor(.primary)
                Spacer()
//                Image(systemName: "heart")
//                    .onTapGesture {
//                        PokeDex.deleteAll()
//                        UserDefaults.standard.set(false, forKey: "ver 1.0.0")
//                    }
//                    .padding(.horizontal)
                //테스트용
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
            MainView()
                .environmentObject(PokeDexViewModel())
        
    }
}
