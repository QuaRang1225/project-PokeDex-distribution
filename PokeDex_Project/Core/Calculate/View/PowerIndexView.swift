//
//  PowerIndexView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/06/23.
//

import SwiftUI

struct PowerIndexView: View {
//    @State var level = "\(50)"
    @State var ac = false
    @State var sameType = false
    @State var adaptability = false
    @State var option1 = "\(1)"
    @State var option2 = "\(0)"
    @State var indiNum = "\(31)"
    @State var eff = "\(252)"
    @State var skill = "\(0)"
    @State var char:CharacterFilter = .none
    @State var rank:RankFilter = .none
    @State var value = ""
    @State var error = true
    
    @EnvironmentObject var vm:PokemonInfoViewModel
    var body: some View {
            VStack(alignment: .leading){
                Text("50레벨 기준")
                powerType
                //levelType
                raceValue
                individual
                effort
                character
                rankFlow
                skillPower
                Group{
                    Button {
                        if /*Int(level)! > 0 && Int(level)! <= 100 && */Int(indiNum)! >= 0 && Int(indiNum)! <= 31 && Int(eff)! >= 0 && Int(eff)! <= 252 {
                            let real = Int((ac ? Double(vm.spAttack.first!) : Double(vm.attack.first!) + (Double(indiNum)!/2) + (Double(eff)!/8) + 5) * char.value)
                            var realAttck: Double = Double(real) * rank.value * Double(skill)! * (sameType ? 1.5 : 1.0)
                            if adaptability{
                                if sameType{
                                    realAttck *= 2.0/1.5
                                }else{
                                    value = "적응력인 특성이라면 자속기술체크를 해주세요!"
                                    error = false
                                }
                            }
                            let endValue = realAttck * (Double(option1)! + Double(option2)!/10)
                          
                            value = String(endValue)
                            error = true
                        }
                        else{
                            value = "개체값은 0~31, 노력치는 0~252사이만 입력할 수 있습니다!"
                            error = false
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 60)
                            .foregroundColor(.secondary)
                            .padding(.vertical,50)
                            .overlay {
                                Text("계산")
                                    .foregroundColor(.white)
                            }
                    }
                    HStack{
                        Spacer()
                        if error{
                            Text("결정력 : ")
                                .bold()
                        }
                        Text(value)
                            .padding(.vertical,20)
                            .font(.title3)
                            .bold()
                            .foregroundColor(error ? .green : .red)
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
        
//            .padding(.top,80)
        .padding(.horizontal)
    }
}

struct PowerIndexView_Previews: PreviewProvider {
    static var previews: some View {
        PowerIndexView()
            .environmentObject(PokemonInfoViewModel())
    }
}

extension PowerIndexView{
    var powerType:some View{
        HStack{
            Toggle(isOn: $ac) {
                if ac{
                    Text("특수")
                }else{
                    Text("물리")
                }
            }
        }
    }
//    var levelType:some View{
//        HStack{
//            Text("레벨")
//            VStack{
//                TextField("입력",text: $level)
//                    .textContentType(.oneTimeCode)
//                    .keyboardType(.numberPad)
//                Divider()
//                    .background(Color.primary)
//            }
//            .offset(y:3)
//            .frame(width: 100)
//            Text("Lv")
//            Spacer()
//            Button {
//                level = "\(50)"
//            } label: {
//                RoundedRectangle(cornerRadius: 10)
//                    .frame(width: 100,height: 30)
//                    .foregroundColor(.secondary).opacity(0.3)
//                    .overlay {
//                        Text("50")
//                            .foregroundColor(.primary)
//                    }
//            }
//            Button {
//                level = "\(100)"
//            } label: {
//                RoundedRectangle(cornerRadius: 10)
//                    .frame(width: 100,height: 30)
//                    .foregroundColor(.secondary).opacity(0.3)
//                    .overlay {
//                        Text("100")
//                            .foregroundColor(.primary)
//                    }
//
//            }
//
//        }
//    }
    var raceValue:some View{
        HStack{
            Text("종족값")
            if ac{
                ForEach(vm.spAttack,id:\.self){ item in
                    Text("\(item)")
                        .foregroundColor(item >= 150 ? .red : .primary)
                        .bold()
                }
            }else{
                ForEach(vm.attack,id:\.self){ item in
                    Text("\(item)")
                        .foregroundColor(item >= 150 ? .red : .primary)
                        .bold()
                }
            }
            
        }
    }
    var individual:some View{
        HStack{
            Text("개체값")
            VStack{
                TextField("입력",text: $indiNum)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                Divider()
                    .background(Color.primary)
            }
            .offset(y:3)
            
            ForEach(IndividualFilter.allCases,id: \.self){ item in
                Button {
                    indiNum = "\(item.value)"
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
    var character:some View{
        HStack{
            Text("성격")
            Spacer()
            Picker("", selection: $char) {
                ForEach(CharacterFilter.allCases,id: \.self){ item in
                    Text(item.name)
                }
            }.accentColor(.primary)
        }
        .padding(.vertical,5)
    }
    var effort:some View{
        HStack{
            Text("노력치")
            VStack{
                TextField("입력",text: $eff)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                Divider()
                    .background(Color.primary)
            }
            .offset(y:3)
            
            ForEach(EffortFilter.allCases,id: \.self){ item in
                Button {
                    eff = "\(item.value)"
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
    var rankFlow:some View{
        HStack{
            Text("랭크")
            Spacer()
            Picker("", selection: $rank) {
                ForEach(RankFilter.allCases,id: \.self){ item in
                    Text(item.name)
                }
            }.accentColor(.primary)
        }
        .padding(.vertical,5)
    }
    var skillPower:some View{
        VStack(alignment: .leading){
            HStack{
                Text("기술위력")
                VStack{
                    TextField("입력",text: $skill)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Divider()
                        .background(Color.primary)
                }
                .offset(y:3)
            }
            Toggle(isOn: $adaptability) {
                Text("적응력")
            }
            Toggle(isOn: $sameType) {
                Text("자속기술")
            }
            Text("추가적으로 특성,도구,필드 기타로 인한 공격/특수공격 상승 하락 등을 설정해주세요!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(height: 80)
            VStack{
                HStack{
                    TextField("입력",text: $option1)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text(" . ")
                    TextField("입력",text: $option2)
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


enum IndividualFilter:String,CaseIterable{
    case v
    case u
    case z
    
    var value:Int{
        switch self{
        case .v:
            return 31
        case .u:
            return 30
        case .z:
            return 0
        }
    }
}

enum CharacterFilter:String,CaseIterable{
    case none
    case up
    case down
    
    var name:String{
        switch self{
        case .none:
            return "무보정 (1배)"
        case .up:
            return "상승 (1.1배)"
        case .down:
            return "하강 (0.9배)"
        }
    }
    var value:Double{
        switch self{
        case .none:
            return 1
        case .up:
            return 1.1
        case .down:
            return 0.9
        }
    }
}

enum EffortFilter:String,CaseIterable{
    case none
    case middle
    case full
    

    var value:Int{
        switch self{
        case .none:
            return 0
        case .middle:
            return 124
        case .full:
            return 252
        }
    }
}
enum RankFilter:String,CaseIterable{
    case hsix
    case hfive
    case hfour
    case hthree
    case htwo
    case hone
    case none
    case one
    case two
    case three
    case four
    case five
    case six
    
    var name:String{
        switch self{
        
        case .hsix:
            return "-6 랭크"
        case .hfive:
            return "-5 랭크"
        case .hfour:
            return "-4 랭크"
        case .hthree:
            return "-3 랭크"
        case .htwo:
            return "-2 랭크"
        case .hone:
            return "-1 랭크"
        case .none:
            return "보통"
        case .one:
            return "+1 랭크"
        case .two:
            return "+2 랭크"
        case .three:
            return "+3 랭크"
        case .four:
            return "+4 랭크"
        case .five:
            return "+5 랭크"
        case .six:
            return "+6 랭크"
        }
    }
    var value:Double{
        switch self{
        case .hsix:
            return 0.25
        case .hfive:
            return 0.285714
        case .hfour:
            return 0.333333
        case .hthree:
            return 0.4
        case .htwo:
            return 0.5
        case .hone:
            return 0.666667
        case .none:
            return 1
        case .one:
            return 1.5
        case .two:
            return 2
        case .three:
            return 2.5
        case .four:
            return 3
        case .five:
            return 3.5
        case .six:
            return 4
        }
    }
}
