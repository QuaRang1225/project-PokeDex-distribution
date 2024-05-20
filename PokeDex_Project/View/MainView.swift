//
//  MainView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import SwiftUI
import Kingfisher

struct MainView: View {
    let columns =  [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    let typeColumns =  [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    let monsterball = "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"
    @State var query = ""
    @State var regionChange = false
    @State var search = false
    @State var filter:RegionFilter = .national
    @State var types:[String] = []
    @State var type_1 = ""
    @State var type_2 = ""
    
    @StateObject var vm = PokemonViewModel(pokemonList: [], pokemon: nil)
    var body: some View {
        ZStack{
            TabView{
                illustratedView
                    .tabItem {
                        VStack{
                            Image(systemName: "book.closed")
                            Text("도감 ")
                        }
                    }
                Text("")
                    .tabItem {
                        VStack{
                            Image(systemName: "bookmark")
                            Text("내 포켓몬")
                        }
                    }
            }
            .accentColor(.primary)
            if regionChange{
                filterView
            }
        }
        .sheet(isPresented: $search){
            serachView
                .presentationDetents([.fraction(0.6)])
            
        }
        .onAppear{
            vm.fetchPokemonList(page: vm.currentPage, region: filter.rawValue, type_1: type_1 , type_2: type_2, query: query)
        }
        
    }
}

#Preview {
    NavigationStack{
        MainView(vm: PokemonViewModel(pokemonList: [], pokemon: nil))
    }
}

extension MainView{
    var pokemonListView:some View{
        LazyVGrid(columns: columns){
            ForEach(vm.pokemonList,id:\.self){ pokemon in
                VStack{
                    HStack(spacing: 0){
                        KFImage(URL(string:monsterball))
                            .resizable()
                            .frame(width: 25,height: 25)
                        Text(String(format: "%04d", pokemon.id))
                    }
                    NavigationLink {
                        PokemonView(pokemonId: pokemon.base.num)
                            .navigationBarBackButtonHidden()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: UIScreen.main.bounds.width/3)
                            .foregroundColor(.typeColor(pokemon.color).opacity(0.15))
                            .overlay {
                                KFImage(URL(string:pokemon.base.image ))
                                    .resizable()
                                    .padding(.bottom)
                                
                            }
                    }
                    
                    Text(pokemon.name)
                    HStack(spacing: 5){
                        ForEach(pokemon.base.types,id:\.self){ type in
                            TypesView(type: type, width: 70, height: 15, font: .system(size: 10))
                        }
                    }.padding(.bottom,10)
                    
                }
                .font(.caption)
                .bold()
                
                if vm.pokemonList.last == pokemon,vm.maxPage > vm.currentPage{
                    ProgressView()
                        .environment(\.colorScheme, .light)
                        .onAppear{
                            vm.fetchPokemonList(page: vm.currentPage + 1, region: filter.rawValue, type_1: type_1 , type_2: type_2, query: query)
                        }
                }
            }
        }
    }
    var filterView:some View{
        ZStack(alignment: .topLeading){
            Color.clear.ignoresSafeArea()
                .background(Material.thin)
            Button {
                regionChange = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .padding()
            }
            .foregroundStyle(.primary)
            ScrollView(showsIndicators:false){
                ForEach(RegionFilter.allCases,id: \.self){ region in
                    Button {
                        filter = region
                        vm.pokemonList = []
                        vm.currentPage = 1
                        vm.fetchPokemonList(page: vm.currentPage, region: region.rawValue, type_1: type_1 , type_2: type_2, query: query)
                        regionChange = false
                    } label: {
                        Text(region.rawValue)
                            .padding()
                            .bold()
                            .foregroundColor(.primary)
                    }
                }
                .padding(.top,40)
            }.frame(maxWidth: .infinity)
        }
    }
    var serachView:some View{
        VStack(alignment:.leading){
            Group{
                HStack{
                    Text("필터")
                        .font(.title3)
                        .bold()
                    
                    Spacer()
                    Button {
                        query = ""
                        type_1 = ""
                        type_2 = ""
                        types = []
                    } label: {
                        HStack(spacing: 2){
                            Image(systemName: "arrow.counterclockwise")
                            Text("초기화")
                        }
                    }
                }
                
                
                TextField("포켓몬 이름..",text: $query)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)
                    .overlay(alignment: .trailing) {
                        Button {
                            query = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.trailing)
                                .foregroundColor(.gray)
                        }
                    }
            }.padding()
            
            HStack{
                Text("타입 : ").bold()
                ForEach(types,id:\.self){ type in
                    Button {
                        types = types.filter{ type != $0 }
                    } label: {
                        TypesView(type: type, width: 80, height: 22, font: .callout)
                    }
                }
            }.padding(.horizontal)
            Divider().padding()
            LazyVGrid(columns: typeColumns){
                ForEach(TypeFilter.allCases,id:\.self){ type in
                    Button {
                        if types.count < 2{
                            types.append(type.rawValue)
                        }
                    } label: {
                        TypesView(type: type.rawValue, width: nil, height: 22, font: .callout)
                        
                    }
                    
                    
                }
            }.padding(.horizontal)
            Spacer()
            Button {
                vm.currentPage = 1
                vm.pokemonList = []
                switch types.count{
                case 0: break
                case 1 :
                    type_1 = types[0]
                case 2 :
                    type_1 = types[0]
                    type_2 = types[1]
                default: break
                }
                vm.fetchPokemonList(page: vm.currentPage, region: filter.rawValue, type_1: type_1 , type_2: type_2, query: query)
                
                search = false
            } label: {
                Text("검색")
                    .foregroundStyle(.white)
                    .padding(.top)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.pink)
            }
            
        }
    }
   
    var illustratedView:some View{
        VStack(alignment:.leading){
            HStack{
                Button {
                    withAnimation(.bouncy){
                        regionChange = true
                    }
                    
                } label: {
                    HStack(spacing: 5){
                        Text("\(filter.rawValue)도감 ")
                            .font(.title)
                            .bold()
                        Image(systemName: "chevron.down")
                    }
                    
                }
                Spacer()
                Button {
                    search = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .bold()
                }
            }
            .foregroundColor(.primary)
            
            ScrollView{
                pokemonListView
            }
            
        }
        .padding(10)
    }
}

