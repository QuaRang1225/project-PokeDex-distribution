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
    let typesColumns = [ GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    @State var isSearch = false
    @State var isType = false
    
    @State var text:String = ""
    @State var dexName = "전국도감"
    @State var selectLocation = false
    @State var selectType:[TypeFilter] = []
    @State var types:[TypeFilter] = TypeFilter.allCases
    
    @EnvironmentObject var vm:PokeDexViewModel
    @EnvironmentObject var vmSave:SaveViewModel
    
    var filteredItems: [Row] {
        if text.isEmpty {
            if selectType.isEmpty{
                return vm.array
            }else{
                return vm.array.filter{$0.types.contains(selectType.first?.name ?? "") && $0.types.contains(selectType.last?.name ?? "")}
            }
        }
        else {
            if selectType.isEmpty{
                return vm.array.filter { String($0.name).contains(text) || String($0.num).contains(text)}
            }else{
                return vm.array.filter{$0.types.contains(selectType.first?.name ?? "") && $0.types.contains(selectType.last?.name ?? "") && (String($0.name).contains(text) || String($0.num).contains(text))}
            }
            
        }
    }
    

    
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack(alignment: .leading,spacing: 0){
                    Section(header: header){
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
                                                .environmentObject(vmSave)
                                        } label: {
                                            DexRowView(row: item)
                                        }
                                        .padding(.bottom,5)
                                    }
                                }.padding(.bottom)

                            }.padding(.horizontal).padding(.top)
                        }.refreshable {
                            vm.dexNum()
                        }
                    }
                }
                if selectLocation{
                    Color.clear.ignoresSafeArea()
                        .background(.regularMaterial)
                    VStack(spacing:20){
                        ScrollView(showsIndicators: false){
                            Spacer().frame(height: 80)
                            ForEach(LocationFilter.allCases,id:\.self){ loc in
                                Button {
                                    dexName = loc.name
                                    vm.location = loc
                                    selectLocation = false
                                } label: {
                                    Text(loc.name)
                                        .bold()
                                        .foregroundColor(.primary)
                                }.padding(.vertical,7.5)
                                
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
            .ignoresSafeArea()
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
                NavigationLink {
                    MySaveView()
                        .environmentObject(vmSave)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(systemName: "star.fill")
                        
                }
                .foregroundColor(.primary)
                .padding(.horizontal)

               
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
            }.padding(.top,50)
            
            
            if isSearch{
                if isType{
                    filter
                }
                HStack(alignment: .center){
                    Button {
                        withAnimation {
                            isType.toggle()
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .bold()
                            .font(.title3)
                            .offset(y: 5)
                            .padding(.trailing,15)
                    }
                    .foregroundColor(.primary)
                    SearchBarView(text: $text)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .padding(.top)
                }
                
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
                .environmentObject(SaveViewModel())
    }
}

extension MainView{
    var filter:some View{
        VStack(alignment: .leading){
            HStack{
                Text("타입 필터 : ")
                    .font(.caption)
                    .bold()
                ForEach(selectType,id: \.self) { type in
                    Button {
                        selectType.removeAll {$0.name == type.name}
                    } label: {
                        TypeComponentView(type: type.name)
                    }
                }
            }
            .padding([.leading,.top])
            .padding(.bottom,10)
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    ForEach(types,id: \.self){ type in
                        Button {
                            if selectType.count < 2{
                                selectType.append(type)
                            }
                        } label: {
                            Capsule()
                                .stroke(lineWidth: 2)
                                .frame(width: 100,height: 40)
                                .overlay {
                                    Text(type.name)
                                        .bold()
                                        .foregroundColor(.primary)
//                                        .shadow(color:.black,radius: 5)
                                }
                                .foregroundColor(Color.typeColor(types: type.name))
//                                .background{
//                                    Capsule()
//                                        .frame(width: 100,height: 40)
//                                        .foregroundColor(.white)
//                                }
                                .padding(.bottom,5)
                                
                        }
                        .padding(.top,5)
                        .padding(.leading,5)
                    }
                }
            }
        }
    }
}
enum TypeFilter:CaseIterable{
    case grass
    case fire
    case water
    case normal
    case dark
    case eletronic
    case ice
    case rock
    case ground
    case flying
    case fighting
    case fairy
    case steel
    case psychic
    case bug
    case poison
    case ghost
    case dragon
    
    var name:String{
        switch self{
        case .grass:
            return "풀"
        case .fire:
            return "불꽃"
        case .water:
            return "물"
        case .normal:
            return "노말"
        case .dark:
            return "악"
        case .eletronic:
            return "전기"
        case .ice:
            return "얼음"
        case .rock:
            return "바위"
        case .ground:
            return "땅"
        case .flying:
            return "비행"
        case .fighting:
            return "격투"
        case .fairy:
            return "페어리"
        case .steel:
            return "강철"
        case .psychic:
            return "에스퍼"
        case .bug:
            return "벌레"
        case .poison:
            return "독"
        case .ghost:
            return "고스트"
        case .dragon:
            return "드래곤"
            
        }
    }
}
