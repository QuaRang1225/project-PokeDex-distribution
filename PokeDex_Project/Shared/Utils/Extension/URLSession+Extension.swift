//
//  APIClient.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/16/25.
//

import Foundation

// MARK: - API 요청 후 JSON 디코딩
extension URLSession {
    func requestDecoding<T: Decodable>(_ type: T.Type, urlRequest: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badServerResponse
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            return decoded
        } catch let error as URLError {
            throw NetworkError.networkError(error)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
