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
    @State var selectLocation = false
    @State var dexName = "전국도감"
    
    @EnvironmentObject var vm:PokeDexViewModel
    
    var filteredItems: [PokeDex] {
        if text.isEmpty {
            return vm.model
        } else {
            return vm.model.filter { String($0.name).contains(text) || String($0.num).contains(text)}
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
                                        PokemonInfoView(num: item.num)
                                            .navigationBarBackButtonHidden()
                                    } label: {
                                        DexRowView(row: item)
                                    }
                                    .padding(.bottom,5)
                                }
                            }

                        }.padding(.horizontal).padding(.top)
                    }.onTapGesture {
                        isSearch = false
                    }.refreshable {}
                }
                if selectLocation{
                    Color.clear.ignoresSafeArea()
                        .background(.regularMaterial)
                    VStack(spacing:30){
                        ForEach(LocationFilter.allCases,id:\.self){ loc in
                            Button {
                                dexName = loc.name
                                vm.location = loc
                                selectLocation = false
                            } label: {
                                Text(loc.name)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                            
                        }
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
            vm.model = Array(PokeDex.findAll())
            vm.model.sort(by: {$0.num < $1.num})
            //vm.get()
        }
//        .onChange(of: vm.location) { _ in
//            vm.cancelTask()
//            if ((vm.taskHandle?.isCancelled) != nil){
//                vm.model.removeAll()
//                vm.get()
//            }
//        }
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
                        .foregroundColor(.primary)
                }
                
                Spacer()
//                Button {
//                    //vm.get()
//                } label: {
//                    Image(systemName:"arrow.triangle.2.circlepath")
//                        .bold()
//                        .font(.title3)
//                        .foregroundColor(.primary)
//                }
//                .padding(.trailing)
                Button {
//                    PokeDex.deleteAll()
                    UserDefaults.standard.set(false, forKey: "ver 1.0.0")
                } label: {
                    Image(systemName:"trash")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                .padding(.trailing)
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
