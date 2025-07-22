//
//  Color.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import Foundation
import SwiftUI

// MARK: - Color
extension Color{
    /// 타입 -> 색상
    static func typeColor(_ types:String)->Color{
        return Color(types)
    }
}
