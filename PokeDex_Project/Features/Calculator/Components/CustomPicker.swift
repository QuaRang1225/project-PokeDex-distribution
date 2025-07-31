//
//  CustomPicker.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/31/25.
//

import Foundation

/// 커스텀 Picker
struct CustomPicker<T: Hashable & LosslessStringConvertible>: View {
    @Binding var selected: T
    let options: [String]
    let color: Color

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                if let value = T(option) {
                    Button {
                        selected = value
                    } label: {
                        Text(option)
                    }
                }
            }
        } label: {
            HStack {
                Text(selected.description)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .rotationEffect(Angle(degrees: 180))
                    .foregroundColor(color)
            }
            .padding(.horizontal)
            .frame(height: 40)
        }
    }
}
