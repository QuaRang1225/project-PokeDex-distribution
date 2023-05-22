//
//  Sequence.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/05/22.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
