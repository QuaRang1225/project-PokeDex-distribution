//
//  PowerView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/23/24.
//
import SwiftUI

struct PowerView: View {
    let stats:(attack:Int,sAttack:Int)
    @State var ac = false
    @State var individual = "\(31)"
    @State var effort = "\(252)"
    
    @State var value = ""
    @State var error = true
    
    
    @State var sameType = false
    @State var adaptability = false
    @State var option = ("\(0)","\(1)")
    
    
    @State var skill = "\(0)"
    @State var char:CharacterFilter = .none
    @State var rank:RankFilter = .none
    
    var body: some View {
        VStack(alignment: .leading){
            resultView
            ScrollView(showsIndicators: false){
                powerType
                raceValue
                individualView
                effortView
                character
                rankFlow
                skillPower
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PowerView(stats:(attack:1,sAttack:2))
}

extension PowerView{
    
    var resultView:some View{
        VStack{
            HStack{
                if error{
                    Text("결정력 : ")
                        .bold()
                }
                Text(value)
                    .bold()
                    .foregroundColor(error ? .green : .red)
                Spacer()
                Button {
                    calculate()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width:60,height: 40)
                        .foregroundColor(.secondary)
                        .overlay {
                            Text("계산")
                                .foregroundColor(.white)
                        }
                }
            }
            Divider()
        }
        
    }
    var powerType:some View{
        VStack(alignment: .leading) {
            Text("50레벨 기준")
            Toggle(isOn: $ac) {
                Text(ac ? "특수" : "물리")
            }
        }
    }
    var raceValue:some View{
        HStack{
            Text("종족값")
            Text(ac ? "\(stats.attack)" : "\(stats.sAttack)")
                .bold()
            Spacer()
        }
    }
    var individualView:some View{
        HStack{
            Text("개체값")
            VStack{
                TextField("입력",text: $individual)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                Divider()
                    .background(Color.primary)
            }
            .offset(y:3)
            
            ForEach(IndividualFilter.allCases,id: \.self){ item in
                Button {
                    individual = "\(item)"
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
    var effortView:some View{
        HStack{
            Text("노력치")
            VStack{
                TextField("입력",text: $effort)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                Divider()
                    .background(Color.primary)
            }
            .offset(y:3)
            
            ForEach(EffortFilter.allCases,id: \.self){ item in
                Button {
                    effort = "\(item.rawValue)"
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50,height: 30)
                        .foregroundColor(.secondary).opacity(0.3)
                        .overlay {
                            Text("\(item.rawValue)")
                                .foregroundColor(.primary)
                        }
                    
                }
            }
        }.padding(.vertical,5)
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
                    TextField("입력",text: $option.0)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text(" . ")
                    TextField("입력",text: $option.1)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text("배")
                }
                Divider()
                    .background(Color.primary)
            }
        }
    }
    func calculate(){
        guard 0...31 ~= Int(individual)!,
              0...252 ~= Int(effort)!
        else{
            value = "개체값은 0~31, 노력치는 0~252사이만 입력할 수 있습니다!"
            error = false
            return
        }
        
        let real = Int(((ac ? Double(stats.sAttack) : Double(stats.attack)) + (Double(individual)!/2) + (Double(effort)!/8) + 5) * char.value)
        
        var realAttck = Double(real) * rank.rawValue * Double(skill)! * (sameType ? 1.5 : 1.0)
        
        
        if adaptability{
            if sameType{
                realAttck *= 2.0/1.5
            }else{
                value = "적응력인 특성이라면 자속기술체크를 해주세요!"
                error = false
            }
        }
        let o1 = Double(option.0)!
        let o2 = Decimal(Double(option.1)!) / pow(10, Int(Double(option.1.count)))
        let endValue = realAttck * (o1 + Double(truncating: o2 as NSNumber))
        
        value = String(endValue)
        error = true
    }
}


