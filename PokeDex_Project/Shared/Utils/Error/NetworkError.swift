//
//  NetworkError.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/16/25.
//

import Foundation

enum NetworkError: Error {
    case badServerResponse
    case serverError(Int)
    case networkError(URLError)
    case decodingFailed
}
