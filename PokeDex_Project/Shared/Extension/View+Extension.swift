//
//  View+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/22/25.
//

import Foundation
import SwiftUI

/// View 관련 확장사항
extension View {
    func onVisible(_ action: @escaping () -> Void) -> some View {
        self.modifier(VisibleModifier(action: action))
    }
}
