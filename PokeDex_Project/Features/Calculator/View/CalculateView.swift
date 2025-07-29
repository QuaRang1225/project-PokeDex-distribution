////
////  CalculateView.swift
////  PokeDex_Project
////
////  Created by 유영웅 on 5/21/24.
////
//
//import SwiftUI
//import Kingfisher
//
//struct CalculateView: View {
//    let pokemon:RealmPokemon
//    
//    @StateObject var vm = CalculateViewModel()
//    @Environment(\.dismiss) var dismiss
//    var body: some View {
//        VStack{
//            Group{
//                hederView
//                DexNumView(pokemon: pokemon).padding(.vertical)
//            }.padding(.horizontal)
//            categoryView
//            TabView(selection: $vm.calculate){
//                PowerView(stats: (pokemon.stats?[1] ?? 0,pokemon.stats?[3] ?? 0))
//                    .tag(CalculateFilter.attack)
//                DefenseView(stats: (pokemon.stats?[0] ?? 0,pokemon.stats?[2] ?? 0,pokemon.stats?[4] ?? 0))
//                    .tag(CalculateFilter.defense)
//                
//            }
//        }
//    }
//}
//
//#Preview {
//    CalculateView(pokemon: RealmPokemon(id: "dasasda", num: 1, name: "안뇽", image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/10080.png", types: ["독","풀"],stats: [1,2,3,4,5,6,7]))
//}
//
//extension CalculateView{
//    var hederView:some View{
//        ZStack{
//            HStack{
//                Button {
//                    dismiss()
//                } label: {
//                    Image(systemName: "chevron.left")
//                }
//                .foregroundColor(.primary)
//                Spacer()
//            }
//            Text("계산기")
//                .bold()
//        }
//        .font(.title3)
//    }
//    var categoryView:some View{
//        GeometryReader{ geo in
//            let width = geo.size.width
//            HStack(spacing:0){
//                ForEach(CalculateFilter.allCases,id:\.self){ item in
//                    Button {
//                        withAnimation(.easeIn(duration: 0.2)){
//                            vm.calculate = item
//                        }
//                    } label: {
//                        Text(item.name)
//                            .font(.callout)
//                            .bold()
//                            .foregroundColor(vm.calculate == item ? .primary : .secondary)
//                        
//                    }.frame(maxWidth: .infinity)
//                }
//            }
//            .overlay(alignment: .leading){
//                Capsule()
//                    .frame(width: geo.size.width/2,height: 3)
//                    .offset(x:vm.indicatorOffset(width: width)).padding(.top,45)
//                
//            }
//            .background{
//                Divider().padding(.top,45)
//            }
//        }.frame(height: 40)
//    }
//}
