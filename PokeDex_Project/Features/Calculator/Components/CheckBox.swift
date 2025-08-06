//
//  CheckBox.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/31/25.
//

import SwiftUI

/// 체크 박스
struct CheckBox: View {
    let label: String
    let color: Color
    var isChecked: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Label {
                Text(label)
                    .font(.device)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? color : .gray)
            }
            .padding(.vertical, 5)
        }
        .buttonStyle(.plain)
    }
}
