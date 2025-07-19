//
//  NetworkError.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/16/25.
//

import Foundation

/// 네트워크 에러
enum NetworkError: Error, Equatable {
    case badServerResponse
    case serverError(Int)
    case networkError(URLError)
    case decodingFailed
}

// MARK: - 네트워크 에러 메세지 정의
extension NetworkError {
    var errorMessage: String {
        switch self {
        case .badServerResponse:
            return "서버로부터 잘못된 응답을 받았습니다."
        case .serverError(let code):
            return "서버 에러가 발생했습니다. (코드: \(code))"
        case .networkError(let urlError):
            return "네트워크 연결에 실패했습니다: \(urlError.localizedDescription)"
        case .decodingFailed:
            return "데이터를 해석하는 데 실패했습니다."
        }
    }
}
