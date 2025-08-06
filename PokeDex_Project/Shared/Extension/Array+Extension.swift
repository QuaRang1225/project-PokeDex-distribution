//
//  Array<Int>+Extension.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/24/25.
//

import Foundation

// MARK: - 모든 Array에서 사용 가능
extension Array {
    /// 배열의 요소 하나하나 병렬적으로 빋동기 이벤트 실행 메서드
    func fetchAsync<T>(action: @escaping (Element) async throws -> T) async throws -> [T] {
        try await withThrowingTaskGroup(of: T.self) { group in
            for arr in self {
                group.addTask {
                    try await action(arr)
                }
            }
            
            var results: [T] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
    }
}

// MARK: - [Int]만 사용 가능
extension Array<Int> {
    /// 마지막 요소는 해당 배열의 합계 추가
    var addSum: [Int] {
        let sum = self.reduce(0, +)
        return self + [sum]
    }
}

