//
//  Optional+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/24/25.
//

import Foundation

// MARK: - Optional
extension Optional {
    /// Optional이 nil이거나, 컬렉션이 비어 있을 경우 defaultValue를 반환하는 메서드
    func unWrapOrDefault(_ defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        switch self {
        case .some(let value as any Collection):
            return value.isEmpty ? defaultValue() : value as! Wrapped
        case .some(let value):
            return value
        case .none:
            return defaultValue()
        }
    }
}
