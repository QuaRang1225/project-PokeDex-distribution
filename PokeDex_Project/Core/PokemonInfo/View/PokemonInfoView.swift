//
//  PokemonInfoView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/27.
//

import SwiftUI
import Kingfisher


struct PokemonInfoView: View {
    @StateObject var vm = PokemonInfoViewModel()
    @Binding var back:Bool
    let coloumn = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    let num:Int
    var body: some View {
            VStack{
                header
                ScrollView{
                    Group{
                        HStack(spacing: 0){
                            KFImage(URL(string: "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"))
                            Text(String(format: "%04d",num))
                                .bold()
                        }
                        .padding(.top,30)
                        .padding(.bottom,20)
                        ZStack{
                            BallImage()
                                .frame(width: 200,height: 200)
                            KFImage(URL(string: vm.image))
                                .resizable()
                                .frame(width: 200,height: 200)
                            
                        }
                    }
                    
                    
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 75,height: 25)
                            .foregroundColor(Color.typeColor(types: vm.types.first ?? ""))
                            .overlay {
                                Text(vm.types.first ?? "")
                                    .shadow(color: .black, radius: 2)
                                    .padding(.horizontal)
                                    .padding(2)
                            }

                        if vm.types.count > 1 {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 75,height: 25)
                                .foregroundColor(Color.typeColor(types: vm.types.last ?? ""))
                                .overlay {
                                    Text(vm.types.last ?? "")
                                        .shadow(color: .black, radius: 2)
                                        .padding(.horizontal)
                                        .padding(2)
                                }
                        }
                    }
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                    
                    HStack{
                        Text(vm.genera)
                        Spacer()
                        Text("키 : " + String(format: "%.1f", Double(vm.height)*0.1) + "m")
                        Spacer()
                        Text("몸무게 : " + String(format: "%.1f", Double(vm.weight)*0.1) + "kg")
                        
                    }
                    .padding(.vertical,5)
                    .padding(.horizontal,30)
                    VStack{
                        HStack{
                            Group{
                                Text("알그룹")
                                Text("성비")
                                Text("포획률")
                            }.frame(maxWidth: .infinity)
                            
                        }
                        .bold()
                        .padding(.bottom,5)
                        HStack{
                            Group{
                                HStack(spacing:0){
                                    ForEach(vm.eggGroup,id:\.self){
                                        Text($0)
                                        if vm.eggGroup.count > 1,$0 != vm.eggGroup.last{
                                            Text("  ")
                                        }
                                        
                                    }
                                }
                                VStack{
                                    if vm.gender.contains(1){
                                        Text("성별 없음")
                                    }else{
                                        Text("수컷 : \(String(format: "%.1f", vm.gender.first ?? 0))%")
                                        Text("암컷 : \(String(format: "%.1f", vm.gender.last ?? 0))%")
                                    }
                                    
                                }
                                Text("\(vm.get)")
                            }.frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical,15)
                    .background(Color.gray.opacity(0.2).cornerRadius(20))
                    .padding()
                    Text("특성")
                        .font(.title3)
                        .bold()
                    VStack{
                        
                        Group{
                            VStack(alignment:.leading, spacing:0){
                                ForEach(Array(zip(vm.char,vm.charDesc)),id:\.0){ (char,desc) in
                                    HStack(spacing: 0){
                                        Text(char)
                                            .padding(.trailing)
                                            .bold()
                                        Text(desc.replacingOccurrences(of: "\n", with: " "))
                                    }
                                }.padding(.bottom)
                               // if !vm.hiddenChar.keys.contains("no"){
                                    ForEach(Array(zip(vm.hiddenChar,vm.hiddenCharDesc)),id:\.0){ (char,desc) in
                                        HStack(spacing: 0){
                                            Text(char).bold()
                                            Image(systemName:"questionmark.circle.fill")
                                                .padding(.trailing)
                                            Text(desc.replacingOccurrences(of: "\n", with: " "))
                                        }
                                    }
                               // }
                                
                            }
                        
                        }.frame(maxWidth: .infinity,alignment:.leading)
                    }
                    
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray.opacity(0.5)))
                    .padding(.horizontal)
                    .padding(.bottom,20)
                    Text("종족값")
                        .font(.title3)
                        .bold()
                    HStack{
                        Group{
                            VStack{
                                Text("HP")
                                    .bold()
                                ForEach(vm.hp,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("공격")
                                    .bold()
                                ForEach(vm.attack,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("방어")
                                    .bold()
                                ForEach(vm.defense,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("특공")
                                    .bold()
                                ForEach(vm.spAttack,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("특방")
                                    .bold()
                                ForEach(vm.spDefense,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("스피드")
                                    .bold()
                                ForEach(vm.speed,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 150 ? .red : .primary)
                                        .bold()
                                }
                            }
                            VStack{
                                Text("합계")
                                    .bold()
                                ForEach(vm.avr,id:\.self){ item in
                                    Text("\(item)")
                                        .foregroundColor(item > 600 ? .red : .primary)
                                        .bold()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                    }
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray.opacity(0.5)))
                    .padding(.horizontal)
                    .padding(.bottom)
                    VStack{
                        Group{
                            Text("진화")
                                .font(.title3)
                                .bold()
                            VStack{
                                HStack(spacing: 30){
                                    ForEach(Array(zip(vm.first,vm.firstName)),id:\.0){ (image,name) in
                                        VStack{
                                            KFImage(URL(string: image)!)
                                                .resizable()
                                                .frame(width: 100,height:100)
                                                .background(BallImage())
                                            Text(name)
                                        }
                                        
                                    }
                                }
                                if vm.second.count > 3{
                                    Image(systemName: "chevron.down")
                                        .bold()
                                        .padding()
                                }
                                HStack(spacing: 30){
                                    if vm.second.count > 3{
                                        LazyVGrid(columns: coloumn,alignment:.center) {
                                            ForEach(Array(zip(vm.second,vm.secondName)),id:\.0){ (image,name) in
                                                VStack{
                                                    
                                                    KFImage(URL(string: image)!)
                                                        .resizable()
                                                        .frame(width: 100,height:100)
                                                        .background(BallImage())
                                                    Text(name)
                                                }
                                                
                                            }
                                        }
                                    }else{
                                        ForEach(Array(zip(vm.second,vm.secondName)),id:\.0){ (image,name) in
                                            VStack{
                                                if vm.second.count != 0{
                                                    Image(systemName: "chevron.down")
                                                        .bold()
                                                        .padding()
                                                }
                                                KFImage(URL(string: image)!)
                                                    .resizable()
                                                    .frame(width: 100,height:100)
                                                    .background(BallImage())
                                                Text(name)
                                            }
                                            
                                        }
                                    }
                                }
                                
                                HStack(spacing: 30){
                                    ForEach(Array(zip(vm.third,vm.thirdName)),id:\.0){ (image,name) in
                                        VStack{
                                            if vm.third.count != 0{
                                                Image(systemName: "chevron.down")
                                                    .bold()
                                                    .padding()
                                            }
                                            KFImage(URL(string: image)!)
                                                .resizable()
                                                .frame(width: 100,height:100)
                                                .background(BallImage())
                                            Text(name)
                                        }
                                        
                                    }
                                }
                                HStack(spacing: 30){
                                    ForEach(Array(zip(vm.forth,vm.forthName)),id:\.0){ (image,name) in
                                        VStack{
                                            if vm.forth.count != 0{
                                                Image(systemName: "chevron.down")
                                                    .bold()
                                                    .padding()
                                            }
                                            KFImage(URL(string: image)!)
                                                .resizable()
                                                .frame(width: 100,height:100)
                                                .background(BallImage())
                                            Text(name)
                                        }
                                        
                                    }
                                }
                            }.padding()
                        }
                    }.padding(.vertical)
                   
                    VStack{
                        Text("도감설명")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth:.infinity)
                        VStack(alignment: .leading) {
                            ForEach(Array(Set(vm.desc)).filter({$0.range(of: "[가-힣]+", options: .regularExpression) != nil}),id:\.self){ item in
                                HStack{
                                    Circle()
                                        .frame(width:5,height:5)
                                        .padding(.trailing,5)
                                    Text(item.replacingOccurrences(of: "\n", with: " "))
                                        .padding(.bottom,5)
                                }
                                
                            }
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray.opacity(0.5)))
                            .padding(.horizontal)
                    }
                    
                }
            }
        .onAppear{
            vm.getInfo(num: num)
        }
        
    }
    var header:some View{
        ZStack{
            HStack{
                Button {
                    back = false
                } label: {
                    Image(systemName: "chevron.left")
                }
                .foregroundColor(.primary)

                
                Spacer()
                Image(systemName: "star")
                    .onTapGesture {
                        vm.reset(num: 10092)
                    }
            }
            Text(vm.name)
                .bold()
                .font(.title3)
        }
        .padding(.horizontal,20)
    }
}

struct PokemonInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoView(back: .constant(true),num: 20)
    }
}

