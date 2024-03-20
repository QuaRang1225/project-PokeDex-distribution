//
//  DefenseIndexView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/06/23.
//

import SwiftUI

struct DefenseIndexView: View {
//    @State var level = "\(50)"
    @State var hpIndiNum = "\(31)"
    @State var defIndiNum = "\(31)"
    @State var sDefIndiNum = "\(31)"
    @State var hpeff = "\(252)"
    @State var defEff = "\(252)"
    @State var sDefff = "\(252)"
    @State var doption1 = "\(1)"
    @State var doption2 = "\(0)"
    @State var boption1 = "\(1)"
    @State var boption2 = "\(0)"
    @State var defchar:CharacterFilter = .none
    @State var sdefchar:CharacterFilter = .none
    @State var value = ""
    @State var error = true
    
    @EnvironmentObject var vm:PokemonInfoViewModel
    var body: some View {
        VStack(alignment: .leading) {
//            levelType
//            Text("50레벨 기준")
//                .padding(.bottom,5)
//            defense
//            individual
//            effort
//            character
//            skillPower
//            Group{
//                Button {
//                    if Int(hpIndiNum)! <= 31 && Int(defIndiNum)! >= 0 && Int(defIndiNum)! <= 31 && Int(sDefIndiNum)! >= 0 && Int(sDefIndiNum)! <= 31 && Int(hpeff)! >= 0 && Int(hpeff)! <= 252 && Int(defEff)! >= 0 && Int(defEff)! <= 252 && Int(sDefff)! >= 0 && Int(sDefff)! <= 252{
//                        
//                        let hpPoint:Int = Int(Double(vm.hp.first!) + (Double(hpIndiNum)!/2) + (Double(hpeff)!/8) + 10.0 + 50.0)
//                        let defPoint:Int = Int((Double(vm.defense.first!) + (Double(defIndiNum)!/2) + (Double(defEff)!/8) + 5) * defchar.value)
//                        let sdefPoint:Int = Int((Double(vm.spDefense.first!) + (Double(sDefIndiNum)!/2) + (Double(sDefff)!/8) + 5) * sdefchar.value)
//                        
//                        let doption1Value = Double(doption1)!
//                        let doption2Value = Decimal(Double(doption2)!) / pow(10, Int(Double(doption2.count)))
//                        let dendValue = Double(hpPoint) * (Double(defPoint)/0.411) * (doption1Value + Double(truncating: doption2Value as NSNumber))
//                        
//                        let boption1Value = Double(boption1)!
//                        let boption2Value = Decimal(Double(boption2)!) / pow(10, Int(Double(boption2.count)))
//                        let bendValue = Double(hpPoint) * (Double(sdefPoint)/0.411) * (boption1Value + Double(truncating: boption2Value as NSNumber))
//                        
//                        value = "방어 - \(dendValue)\n특수방어 -  \(bendValue)"
//                        error = true
//                    }
//                    else{
//                        value = "레벨은 0~100, 개체값은 0~31, 노력치는 0~252사이만 입력할 수 있습니다!"
//                        error = false
//                    }
//                } label: {
//                    RoundedRectangle(cornerRadius: 20)
//                        .frame(height: 60)
//                        .foregroundColor(.secondary)
//                        .padding(.vertical,50)
//                        .overlay {
//                            Text("계산")
//                                .foregroundColor(.white)
//                        }
//                }
//                HStack{
//                    Spacer()
//                    if error{
//                        Text("결정력 : ")
//                            .bold()
//                    }
//                    Text(value)
//                        .padding(.vertical,20)
//                        .font(.title3)
//                        .bold()
//                        .foregroundColor(error ? .green : .red)
//                    Spacer()
//                }
//                
//                Spacer()
//            }
//            Spacer()
        }
        .padding(.top,10)
    .padding(.horizontal)
    }
}

struct DefenseIndexView_Previews: PreviewProvider {
    static var previews: some View {
        DefenseIndexView()
            .environmentObject(PokemonInfoViewModel())
    }
}

extension DefenseIndexView{
//        var levelType:some View{
//            HStack{
//                Text("레벨")
//                VStack{
//                    TextField("입력",text: $level)
//                        .textContentType(.oneTimeCode)
//                        .keyboardType(.numberPad)
//                    Divider()
//                        .background(Color.primary)
//                }
//                .offset(y:3)
//                .frame(width: 100)
//                Text("Lv")
//                Spacer()
//                Button {
//                    level = "\(50)"
//                } label: {
//                    RoundedRectangle(cornerRadius: 10)
//                        .frame(width: 100,height: 30)
//                        .foregroundColor(.secondary).opacity(0.3)
//                        .overlay {
//                            Text("50")
//                                .foregroundColor(.primary)
//                        }
//                }
//                Button {
//                    level = "\(100)"
//                } label: {
//                    RoundedRectangle(cornerRadius: 10)
//                        .frame(width: 100,height: 30)
//                        .foregroundColor(.secondary).opacity(0.3)
//                        .overlay {
//                            Text("100")
//                                .foregroundColor(.primary)
//                        }
//
//                }
//
//            }
//        }
    
    var defense:some View{
        HStack(spacing: 10){
            HStack{
                Text("HP")
                ForEach(vm.hp,id:\.self){ item in
                    Text("\(item)")
                        .foregroundColor(item >= 150 ? .red : .primary)
                        .bold()
                }
            }.frame(maxWidth: .infinity)
            HStack{
                Text("방어")
                ForEach(vm.defense,id:\.self){ item in
                    Text("\(item)")
                        .foregroundColor(item >= 150 ? .red : .primary)
                        .bold()
                }
            }.frame(maxWidth: .infinity)
            HStack{
                Text("특방")
                ForEach(vm.spDefense,id:\.self){ item in
                    Text("\(item)")
                        .foregroundColor(item >= 150 ? .red : .primary)
                        .bold()
                }
            }.frame(maxWidth: .infinity)
        }
    }
    var individual:some View{
        ForEach(0...2,id: \.self){ index in
            HStack{
                switch index{
                case 0:
                    Text("HP 개체값")
                case 1:
                    Text("방어 개체값")
                case 2:
                    Text("특방 개체값")
                default:
                    Text("")
                }
                
                VStack{
                    switch index{
                    case 0:
                        TextField("입력",text: $hpIndiNum)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                    case 1:
                        TextField("입력",text: $defIndiNum)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                    case 2:
                        TextField("입력",text: $sDefIndiNum)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                    default:
                        Text("")
                    }
                   
                    Divider()
                        .background(Color.primary)
                }
                .offset(y:3)
                
                ForEach(IndividualFilter.allCases,id: \.self){ item in
                    Button {
                        switch index{
                        case 0:
                            hpIndiNum = "\(item.value)"
                        case 1:
                            defIndiNum = "\(item.value)"
                        case 2:
                            sDefIndiNum = "\(item.value)"
                        default: break
                            
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 30,height: 30)
                            .foregroundColor(.secondary).opacity(0.3)
                            .overlay {
                                Text(item.rawValue)
                                    .foregroundColor(.primary)
                            }
                        
                    }
                }
            }
            .padding(.vertical,5)
        }
        
    }
    var effort:some View{
        ForEach(0...2,id: \.self){ index in
            HStack{
                switch index{
                case 0:
                    Text("HP 노력치")
                case 1:
                    Text("방어 노력치")
                case 2:
                    Text("특방 노력치")
                default:
                    Text("")
                }
                VStack{
                    switch index{
                    case 0:
                        TextField("입력",text: $hpeff)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                    case 1:
                        TextField("입력",text: $defEff)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                    case 2:
                        TextField("입력",text: $sDefff)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                    default:
                        Text("")
                    }
                    Divider()
                        .background(Color.primary)
                }
                .offset(y:3)
                
                ForEach(EffortFilter.allCases,id: \.self){ item in
                    Button {
                        switch index{
                        case 0:
                            hpeff = "\(item.value)"
                        case 1:
                            defEff = "\(item.value)"
                        case 2:
                            sDefff = "\(item.value)"
                        default: break
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50,height: 30)
                            .foregroundColor(.secondary).opacity(0.3)
                            .overlay {
                                Text("\(item.value)")
                                    .foregroundColor(.primary)
                            }
                        
                    }
                }
            }.padding(.vertical,5)
        }
    }
    var character:some View{
        
        HStack{
            Text("방어")
            Spacer()
            Picker("", selection: $defchar) {
                ForEach(CharacterFilter.allCases,id: \.self){ item in
                    Text(item.name)
                }
            }
            Text("특방")
            Spacer()
            Picker("", selection: $sdefchar) {
                ForEach(CharacterFilter.allCases,id: \.self){ item in
                    Text(item.name)
                }
            }
        }.accentColor(.primary)
        .padding(.vertical,5)
    }
    var skillPower:some View{
        VStack(alignment: .leading){
            
            Text("추가적으로 특성,도구,필드 기타로 인한 방어/특수방어 상승 하락 등을 설정해주세요!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(height: 80)
            VStack(alignment: .leading){
                Text("방어")
                HStack{
                    TextField("입력",text: $doption1)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text(" . ")
                    TextField("입력",text: $doption2)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text("배")
                }
                Divider()
                    .background(Color.primary)
                Text("특수방어")
                    .padding(.top)
                HStack{
                    TextField("입력",text: $boption1)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text(" . ")
                    TextField("입력",text: $boption2)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text("배")
                }
                Divider()
                    .background(Color.primary)
            }
        }
    }
}
