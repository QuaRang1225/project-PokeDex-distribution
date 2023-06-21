//
//  PokemonInfoView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/27.
//

import SwiftUI
import Kingfisher


struct PokemonInfoView: View {
    
    @State var form = false
    @State var formName = ""
    @State var basic = ""
    
    @StateObject var vm = PokemonInfoViewModel()
    @EnvironmentObject var vmSave:SaveViewModel
//    @EnvironmentObject var vmSave:PokemonSaveViewModel
    
    @Environment(\.dismiss) var dismiss
    let coloumn = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    let num:Int
    
    var body: some View {
        VStack{
            header
            ScrollView{
                thumnail
                info
                charictors
                stats
                evolution
                description
            }.overlay(alignment: .topTrailing) {
                if vm.isRegion.count > 1 || vm.isForm.count > 1{
                    isRegion
                }
            }
        }
        .onTapGesture {
            form = false
        }
        .onAppear{
            vm.getEvol(num: num)
            vm.getSpecies(num: num)
            vm.getPokeon(num: num)
            vm.getregional(num: num)
            vm.getform(num: num)
            basic = vm.image
        }
    }
}

struct PokemonInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoView(num: 916)
            .environmentObject(SaveViewModel())
    }
}
extension PokemonInfoView{
    func getImage(num:Int)->String{
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(num).png"
    }
    var header:some View{
        ZStack{
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
              
                
                Spacer()
                Button {
                    if vmSave.save.contains(where: {$0.num == num}){
                        for i in vmSave.save{
                            if i.num == num{
                                vmSave.deleteData(save: i)
                            }
                        }
                    }else{
                        vmSave.num = num
                        vmSave.image = getImage(num: num)
                        vmSave.name = vm.name
                        vmSave.types = vm.types
                        vmSave.addData()
                    }
                } label: {
                    if vmSave.save.contains(where: {$0.num == num}){
                        Image(systemName: "star.fill")
                    }else{
                        Image(systemName: "star")
                    }
                    
                }

               
            }
            .foregroundColor(.primary)
            Text(vm.name + "\(formName)")
                .bold()
                .font(.title3)
        }
        .padding(.horizontal,20)
    }
    var thumnail:some View{
        VStack{
            HStack(spacing: 0){
                KFImage(URL(string: "https://github.com/PokeAPI/sprites/blob/master/sprites/items/poke-ball.png?raw=true"))
                Text(String(format: "%04d",vm.dexNum))
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
        
    }
    var info:some View{
        VStack(spacing: 0) {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 90,height: 25)
                    .foregroundColor(Color.typeColor(types: vm.types.first ?? ""))
                    .overlay {
                        Text(vm.types.first ?? "")
                            .shadow(color: .black, radius: 2)
                            .padding(.horizontal)
                            .padding(2)
                    }
                
                if vm.types.count > 1 {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 90,height: 25)
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
        }
    }
    var charictors:some View{
        VStack(spacing: 10) {
            Text("특성")
                .font(.title3)
                .bold()
            VStack{
                Group{
                    VStack(alignment:.leading, spacing:5){
                        if !vm.firstChar.isEmpty{
                            HStack(spacing: 0){
                                Text(vm.firstChar)
                                    .padding(.trailing)
                                    .bold()
                                Divider().padding(.horizontal)
                                Text(vm.firstCharDesc.replacingOccurrences(of: "\n", with: " "))
                                    .lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                                
                            }
                        }
                        
                        if !vm.secondChar.isEmpty{
                            Divider()
                            HStack(spacing: 0){
                                Text(vm.secondChar)
                                    .padding(.trailing)
                                    .bold()
                                Divider().padding(.horizontal)
                                Text(vm.secondCharDesc.replacingOccurrences(of: "\n", with: " "))
                                    .lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                                
                            }
                        }
                        if !vm.hiddenChar.isEmpty{
                            Divider()
                            HStack(spacing: 0){
                                Text(vm.hiddenChar)
                                    .bold()
                                Image(systemName: "questionmark.circle")
                                        .padding(.trailing)
                                        .bold()
                                Divider().padding(.horizontal)
                                Text(vm.hiddenCharDesc.replacingOccurrences(of: "\n", with: " ")).lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }.font(.subheadline)
                    
                }.frame(maxWidth: .infinity,alignment:.leading)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray.opacity(0.5)))
            .padding(.horizontal)
            .padding(.bottom,20)
        }
    }
    var stats:some View{
        VStack(spacing: 10) {
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
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("공격")
                            .bold()
                        ForEach(vm.attack,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("방어")
                            .bold()
                        ForEach(vm.defense,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("특공")
                            .bold()
                        ForEach(vm.spAttack,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("특방")
                            .bold()
                        ForEach(vm.spDefense,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("스피드")
                            .bold()
                        ForEach(vm.speed,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 150 ? .red : .primary)
                                .bold()
                        }
                    }
                    VStack{
                        Text("합계")
                            .bold()
                        ForEach(vm.avr,id:\.self){ item in
                            Text("\(item)")
                                .foregroundColor(item >= 600 ? .red : .primary)
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
        }
    }
    var evolution:some View{
        VStack(spacing: 0){
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
                            }.onTapGesture {
                                formName = ""
                                vm.getSpecies(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                vm.getPokeon(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                vm.getregional(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                vm.getform(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
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
                                    }.onTapGesture {
                                        formName = ""
                                        vm.getSpecies(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                        vm.getPokeon(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                        vm.getregional(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                        vm.getform(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
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
                                }.onTapGesture {
                                    formName = ""
                                    vm.getPokeon(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                    vm.getregional(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                    vm.getSpecies(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                    vm.getform(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
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
                            }.onTapGesture {
                                formName = ""
                                vm.getPokeon(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                vm.getregional(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                vm.getSpecies(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                vm.getform(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                            }
                            
                        }
                    }
                }.padding()
            }
        }.padding(.vertical)
    }
    var description:some View{
        VStack{
            Text("도감설명")
                .font(.title3)
                .bold()
                .frame(maxWidth:.infinity)
            VStack(alignment: .leading) {
                ForEach(vm.desc.uniqued(),id:\.self){ item in
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
    var isRegion:some View{
        VStack(alignment: .center){
            ZStack{
                Circle().frame(width: 70,height: 70).foregroundColor(.antiPrimary)
                Circle().frame(width: 70,height: 70).foregroundColor(.secondary).opacity(0.3)
            }.overlay{
                VStack(spacing: 0) {
                    Text("다른폼")
                        .font(.caption)
                        .padding(.vertical,5)
                    Button {
                        withAnimation(.linear(duration: 0.4)){
                            form.toggle()
                        }
                    } label: {
                        Image(systemName:form ?  "chevron.up":"chevron.down")
                            .padding(.bottom,5)
                            .foregroundColor(.primary)
                            
                    }
                }
            }.padding(.bottom,15)
            if form{
                ScrollView(showsIndicators: false){
                    VStack{
                        if !vm.isRegion.isEmpty{
                            if vm.dexNum == 670{
                                ForEach(Array(zip(vm.isForm, vm.isFormname)).indices, id: \.self) { index in
                                    let (image, name) = (vm.isForm[index], vm.isFormname[index])
                                    // 첫 번째 인덱스 사용
                                    ZStack{
                                        Circle().frame(width: 70,height: 70).foregroundColor(.antiPrimary)
                                        Circle().frame(width: 70,height: 70).foregroundColor(.secondary).opacity(0.3)
                                    }.overlay{
                                        VStack(spacing: 0){
                                            KFImage(URL(string: image)!)
                                                .resizable()
                                                .placeholder{
                                                    KFImage(URL(string: vm.isForm.first!))
                                                        .resizable()
                                                }
                                                .scaledToFill()
                                                .frame(width: 50,height: 50)
                                                .onTapGesture {
                                                    if index == 0 {
                                                        // 원하는 작업 수행
                                                        vm.image = basic
                                                        vm.getPokeon(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                                    }else if index == 5{
                                                        vm.getPokeon(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                                    }else{
                                                        
                                                        vm.getPokeon(num: Int(String(image.filter({$0.isNumber}))) ?? 0)
                                                        vm.image = image
                                                    }
                                                    
                                                    formName = ""
                                                    if name != vm.isFormname.first!{
                                                        formName = "(\(name))"
                                                    }
                                                    
                                                }
                                            Text(name).font(.caption2)
                                                .padding(.bottom,5)
                                        }
                                       
                                    }
                                    
                                }
                            }
                            ForEach(Array(zip(vm.isRegion,vm.isRegionName)),id:\.0){ (image,name) in
                                ZStack{
                                    Circle().frame(width: 70,height: 70).foregroundColor(.antiPrimary)
                                    Circle().frame(width: 70,height: 70).foregroundColor(.secondary).opacity(0.3)
                                }.overlay{
                                    VStack(spacing: 0){
                                        KFImage(URL(string: getImage(num: image))!)
                                            .resizable()
                                            .placeholder{
                                                KFImage(URL(string: getImage(num: vm.isRegion.first!)))
                                                    .resizable()
                                            }
                                            .scaledToFill()
                                            .frame(width: 50,height: 50)
                                            .onTapGesture {
                                                vm.getPokeon(num: image)
                                                formName = ""
                                                if name != vm.isRegionName.first!{
                                                    formName = "(\(name))"
                                                }
                                            }
                                        Text(name).font(.caption2)
                                            .padding(.bottom,5)
                                    }
                                   
                                }
                               
                            }
                            
                        }else{
                            
                            ForEach(Array(zip(vm.isForm, vm.isFormname)).indices, id: \.self) { index in
                                let (image, name) = (vm.isForm[index], vm.isFormname[index])
                                // 첫 번째 인덱스 사용
                                ZStack{
                                    Circle().frame(width: 70,height: 70).foregroundColor(.antiPrimary)
                                    Circle().frame(width: 70,height: 70).foregroundColor(.secondary).opacity(0.3)
                                }.overlay{
                                    VStack(spacing: 0){
                                        KFImage(URL(string: image)!)
                                            .resizable()
                                            .placeholder{
                                                KFImage(URL(string: vm.isForm.first!))
                                                    .resizable()
                                            }
                                            .scaledToFill()
                                            .frame(width: 50,height: 50)
                                            .onTapGesture {
                                                if index == 0 {
                                                    // 원하는 작업 수행
                                                    vm.image = basic
                                                }else{
                                                    vm.image = image
                                                }
                                                
                                                formName = ""
                                                if name != vm.isFormname.first!{
                                                    formName = "(\(name))"
                                                }
                                                if num == 493 || num == 773{
                                                    vm.types.removeAll()
                                                    vm.types.append(name)
                                                }
                                            }
                                        Text(name).font(.caption2)
                                            .padding(.bottom,5)
                                    }
                                   
                                }
                                
                            }

                        }
                        
                    }
                    
                }
            }
            
            
        }.padding(.vertical,5)
        .padding()
    }
}

