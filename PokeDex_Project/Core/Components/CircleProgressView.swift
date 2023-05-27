//
//  CircleProgressView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/05/26.
//

import SwiftUI

struct CircleProgressView: View {
    @State private var rotation = 0.0
    @State var num = 0
    let dot = [".",".."]
    
    var body: some View {
        VStack(spacing:20){
            Circle()
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Color.white, Color.red]),
                        center: .center,
                        startAngle: .zero,
                        endAngle: .degrees(360)
                    ),
                    lineWidth: 10
                )
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: rotation))
            HStack{
                Text("도감정보 다운로드 중")
                Text(dot[num])
            }
            
        }
       
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(Animation.default.repeatForever()) {
                num += 1
            }
        }
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView()
    }
}
