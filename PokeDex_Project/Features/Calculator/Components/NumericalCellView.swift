//
//  NumerView.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/31/25.
//

import SwiftUI

/// 수치 핸들러 셀
struct NumericalCellView : View {
    let title: String
    let color: Color
    let arrange: ClosedRange<Int>
    @Binding var value: String
    
    var body: some View {
        HStack {
            TextField("", text: $value)
                .padding()
                .keyboardType(.numberPad)
                .borderSection(title: title)
            Spacer()
            VStack {
                Button {
                    guard let value = Int(value),
                          value < arrange.upperBound
                    else { return }
                    self.value = "\(value + 1)"
                } label: {
                    labelView(text: "+", width: 30)
                }
                Button {
                    guard let value = Int(value),
                          value > arrange.lowerBound
                    else { return }
                    print(value)
                    self.value = "\(value - 1)"
                } label: {
                    labelView(text: "-", width: 30)
                }
            }
            Button {
                self.value = "\(arrange.upperBound)"
            } label: {
                labelView(text: "MAX", width: 60)
            }
            Button {
                self.value = "\(arrange.lowerBound)"
            } label: {
                labelView(text: "MIN", width: 60)
            }
        }
    }
}

// MARK: - 수치 핸들러 셀 컴포넌트 정의
private extension NumericalCellView {
    /// 라벨 뷰
    func labelView(text: String, width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: width)
            .overlay {
                Text(text)
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 1)
            }
            .foregroundStyle(color)
    }
}
