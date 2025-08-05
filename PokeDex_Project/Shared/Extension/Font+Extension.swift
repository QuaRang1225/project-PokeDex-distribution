//
//  Font+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 8/5/25.
//

import Foundation
import SwiftUI

// MARK: - 폰트 확장
extension Font {
    static let device = UIScreen.main.bounds.width < 400 ? Font.caption : Font.body
}
