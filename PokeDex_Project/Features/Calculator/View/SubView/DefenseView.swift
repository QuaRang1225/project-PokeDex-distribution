//
//  DefenseView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/23/24.
//

import SwiftUI

struct DefenseView: View {
    let stats:(hp:Int,defense:Int,sDefense:Int)
    let statsName = ["HP","방어","특방"]
    @State var individual = (hp:"\(31)",defense:"\(31)",sDefense:"\(31)")
    @State var effort = (hp:"\(252)",defense:"\(252)",sDefense:"\(252)")
    @State var character = (defense:CharacterFilter.none,sDefense:CharacterFilter.none)
    @State var option = (df:"\(1)",db:"\(0)",bf:"\(1)",bb:"\(0)")
    @State var value = (d:"",b:"")
    @State var error = true
    
    var body: some View {
        VStack(alignment: .leading) {
            resultView
            ScrollView(showsIndicators: false){
                defense
                individualView
                effortView
                characterView
                skillPower
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    DefenseView(stats: (1,2,3))
}

extension DefenseView{
    var resultView:some View{
        VStack(alignment:.leading){
            HStack{
                if error{
                    Text("결정력 : ")
                        .bold()
                }
                VStack(alignment: .leading){
                    Text(value.d)
                    Text(value.b)
                }
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
    var defense:some View{
        VStack(alignment: .leading){
            Text("50레벨 기준")
                .padding(.bottom,5)
            HStack(spacing: 10){
                HStack{
                    Text("HP")
                    Text("\(stats.hp)").bold()
                }
                HStack{
                    Text("방어")
                    Text("\(stats.defense)").bold()
                }
                HStack{
                    Text("특방")
                    Text("\(stats.sDefense)").bold()
                }
                Spacer()
            }
        }
        
    }
    var individualView:some View{
        ForEach(statsName,id:\.self){ type in
            HStack{
                Text(type + " 개체값")
                VStack{
                    Group{
                        switch type{
                        case "HP":TextField("",text: $individual.hp)
                        case "방어":TextField("",text: $individual.defense)
                        case "특방":TextField("",text: $individual.sDefense)
                        default:Text("")
                        }
                    }
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    Divider()
                        .background(Color.primary)
                }
                ForEach(IndividualFilter.allCases,id: \.self){ item in
                    Button {
                        switch type{
                        case "HP": individual.hp = "\(item.num)"
                        case "방어": individual.defense = "\(item.num)"
                        case "특방": individual.sDefense = "\(item.num)"
                        default: ()
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
        }
    }
    var effortView:some View{
        ForEach(statsName,id:\.self){ type in
            HStack{
                Text(type + " 개체값")
                VStack{
                    Group{
                        switch type{
                        case "HP":TextField("",text: $effort.hp)
                        case "방어":TextField("",text: $effort.defense)
                        case "특방":TextField("",text: $effort.sDefense)
                        default:Text("")
                        }
                    }
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    Divider()
                        .background(Color.primary)
                }
                ForEach(EffortFilter.allCases,id: \.self){ item in
                    Button {
                        switch type{
                        case "HP": effort.hp = "\(item.rawValue)"
                        case "방어": effort.defense = "\(item.rawValue)"
                        case "특방": effort.sDefense = "\(item.rawValue)"
                        default: ()
                        }
                        
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
            }
        }
    }
    var characterView:some View{
        
        HStack{
            Text("방어")
            Spacer()
            Picker("", selection: $character.defense) {
                ForEach(CharacterFilter.allCases,id: \.self){ item in
                    Text(item.name)
                }
            }
            Text("특방")
            Spacer()
            Picker("", selection: $character.sDefense) {
                ForEach(CharacterFilter.allCases,id: \.self){ item in
                    Text(item.name)
                }
            }
        }.accentColor(.primary)
            .padding(.vertical)
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
                    TextField("입력",text: $option.df)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text(" . ")
                    TextField("입력",text: $option.db)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text("배")
                }
                Divider()
                    .background(Color.primary)
                Text("특수방어")
                    .padding(.top)
                HStack{
                    TextField("입력",text: $option.bf)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                    Text(" . ")
                    TextField("입력",text: $option.bb)
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
        guard
            0...31 ~= Int(individual.hp)!,
            0...31 ~= Int(individual.defense)!,
            0...31 ~= Int(individual.sDefense)!,
            0...252 ~= Int(effort.hp)!,
            0...252 ~= Int(effort.defense)!,
            0...252 ~= Int(effort.sDefense)!
        else{
            value.d = "개체값은 0~31, 노력치는 0~252사이만 입력할 수 있습니다!"
            error = false
            return
        }
        let hpPoint = Int(Double(stats.hp) + (Double(individual.hp)!/2) + (Double(effort.hp)!/8) + 60.0)
        let defPoint:Int = Int((Double(stats.defense) + (Double(individual.defense)!/2) + (Double(effort.defense)!/8) + 5) * character.defense.value)
        let sdefPoint:Int = Int((Double(stats.sDefense) + (Double(individual.sDefense)!/2) + (Double(effort.sDefense)!/8) + 5) * character.sDefense.value)
        
        let df = Double(option.df)!
        let db = Decimal(Double(option.db)!) / pow(10, Int(Double(option.db.count)))
        let d = Double(hpPoint) * (Double(defPoint)/0.411) * (df + Double(truncating: db as NSNumber))
        
        let bf = Double(option.bf)!
        let bb = Decimal(Double(option.bb)!) / pow(10, Int(Double(option.bb.count)))
        let b = Double(hpPoint) * (Double(sdefPoint)/0.411) * (bf + Double(truncating: bb as NSNumber))
        
        value = ("방어 - \(String(format: "%.2f", d))","특수방어 -  \(String(format: "%.2f", b))")
        error = true
    }
}

