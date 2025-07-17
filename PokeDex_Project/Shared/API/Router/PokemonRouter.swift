//
//  PokemonRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import Foundation

/// 포켓몬 요청 라우터
enum PokemonRouter: Router {
    
    /// 단일 요청 - 전국도감 번호로 요청
    case pokemon(id: Int)
    /// 포켓몬 리스트요청 (페이지, 지방, 타입1, 타입2, 이름)
    case pokemons(page: Int, region: String, type_1: String, type_2: String, query: String)
    
    var baseUrl: URL {
        return URL(string: Config.awsURL)!
    }
    
    var endPoint: String {
        switch self {
        case let .pokemon(id):
            return "/pokemon/\(id)"
        case .pokemons:
            return "/pokemons"
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .pokemon:
            return [:]
        case let .pokemons(page, region, type_1, type_2, query):
            return [
                "page": "\(page)",
                "region": region,
                "types_1": type_1,
                "types_2": type_2,
                "query": query
            ]
        }
    }
    
    func addQuery(_ url: URL) -> URL? {
        switch self {
        case .pokemons:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            guard let composedURL = components?.url else { return nil }
            return composedURL
        default: return nil
        }
    }
    
    func makeURLRequest() -> URLRequest {
        var url = baseUrl.appendingPathComponent(endPoint)
        
        if let addedQueryUrl = addQuery(url) {
            url = addedQueryUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
}
