//
//  RealmError.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/17/25.
//

import Foundation

/// RealmDB 에러
enum RealmError: Error, Equatable {
    case notFound
    case deleteFailed
}

// MARK: - 에러 메세지
extension RealmError {
    var errorMessage: String {
        switch self {
        case .notFound:
            return "데이터를 찾을 수 없습니다."
        case .deleteFailed:
            return "데이터 삭제에 실패했습니다."
        }
    }
}
