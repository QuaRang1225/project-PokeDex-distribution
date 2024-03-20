//
//  CircleProgressView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/05/26.
//

import SwiftUI
import Kingfisher

struct CircleProgressView: View {
    @State private var rotation = 0.0
    @State var num = 0
    @State var countStart = false
    @State var image = ""
    @State var isCorrect:Bool? = nil
    @State var solveArray:[Int] = []
    @EnvironmentObject var vm:PokeDexViewModel
    
    var body: some View {
        VStack(spacing:0){
            Spacer()
//          solveScreen
//            Spacer()
//            ProgressView("",value: Double(vm.pokeDexCount),total: 1010)
//                
//                .accentColor(.red)
//                .overlay(alignment:.topLeading){
//                    HStack{
//                        Circle()
//                            .stroke(
//                                AngularGradient(
//                                    gradient: Gradient(colors: [Color.clear, Color.red]),
//                                    center: .center,
//                                    startAngle: .zero,
//                                    endAngle: .degrees(360)
//                                ),
//                                lineWidth: 1
//                            )
//                            .frame(width: 10, height: 10)
//                            .rotationEffect(Angle(degrees: rotation))
//                        Text(countStart ?  "도감 정보 다운로드중.." : "리소스 검사 중..")
//                        Text("\(vm.pokeDexCount >= 10 ? (vm.pokeDexCount-10)/10 : (vm.pokeDexCount-10)/10 + 1)%")
//                       
//                    }
//                }.padding(.horizontal,30)
//            
//            Text("최대 3분 정도 소요될 수 있습니다..")
//                .padding()
//            Spacer()
            
        }
        .onChange(of: vm.pokeDexCount){ newValue in
            countStart = true
        }
        .font(.caption)
        
        .onAppear{
            
            numRandom()
            solveArray = solveArray.shuffled()
            DispatchQueue.main.async {  //빌드 5 이걸 썼더니 요동치지 않음
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
        }
        
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView()
            .environmentObject(PokeDexViewModel())
    }
}


extension CircleProgressView{
    var solveScreen:some View{
        VStack{

            Text("포켓몬 전국도감번호 맞추기 퀴즈")
                .font(.title3)
                .bold()
            KFImage(URL(string:image))
                .resizable()
                .frame(width: 200,height: 200)
                .overlay {
                    if let isCorrect =  isCorrect{
                        Image(systemName: isCorrect ? "circle" : "xmark")
                            .resizable()
                            .frame(width: 100,height: 100)
                            .foregroundColor(isCorrect ? .green : .red)
                    }
                }
            ForEach(solveArray,id: \.self){ item in
                Button {
                    if item == num{
                        isCorrect = true
                    }else{
                        isCorrect = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        withAnimation(.default){
                            numRandom()
                            solveArray = solveArray.shuffled()
                        }
                    }
                } label: {
                    Text("No.\(item)")
                        .padding(7)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.antiPrimary) .shadow(color: .primary,radius: 1))
                        .padding(.horizontal,50)
                        .padding(2)
                        .foregroundColor(.primary)
                }
            }
            
            
                
                
        }
        .font(.body)
        
    }
    func numRandom(){
        isCorrect = nil
        solveArray.removeAll()
        let num = Int.random(in: 1...1010)
        self.num = num
        image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(num).png"
        solveArray.append(num)
        for _ in 1...3{
            solveArray.append(Int.random(in: 1...898))
        }
    }
}
