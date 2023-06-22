////
////  MenuTabView.swift
////  PokeDex_Project
////
////  Created by 유영웅 on 2023/06/20.
////
//
//import SwiftUI
//
//struct MenuTabView: View {
//    @State var dexName = "전국도감"
//    @State var selectLocation = false
//    @State var mode = ""
//    @EnvironmentObject var vmSave:SaveViewModel
//    @EnvironmentObject var vm:PokeDexViewModel
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor(Color.antiPrimary)
//    }
//    
//    var body: some View {
//        ZStack{
//            
//            TabView{
//                MainView(selectLocation: $selectLocation, dexName: $dexName)
//                    .environmentObject(vm)
//                    .environmentObject(vmSave)
//                    .tabItem {
//                        Image(systemName: "house.fill")
//                    }
//                MySaveView()
//                    .environmentObject(vmSave)
//                    .tabItem {
//                        Image(systemName: "star.fill")
//                    }
//                
//            }.accentColor(Color.primary)
//            
//            if selectLocation{
//                Color.clear.ignoresSafeArea()
//                    .background(.regularMaterial)
//                VStack(spacing:20){
//                    ScrollView(showsIndicators: false){
//                        Spacer().frame(height: 80)
//                        ForEach(LocationFilter.allCases,id:\.self){ loc in
//                            Button {
//                                dexName = loc.name
//                                vm.location = loc
//                                selectLocation = false
//                            } label: {
//                                Text(loc.name)
//                                    .bold()
//                                    .foregroundColor(.primary)
//                            }.padding(.vertical,7.5)
//                            
//                        }.padding(.bottom)
//                        Button {
//                            selectLocation = false
//                        } label: {
//                            Image(systemName: "xmark.circle.fill")
//                                .foregroundColor(.primary)
//                                .font(.largeTitle)
//                        }
//                    }
//                }
//            }
//        }
//        
//    }
//}
//
//struct MenuTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuTabView()
//            .environmentObject(PokeDexViewModel())
//            .environmentObject(SaveViewModel())
//    }
//}
