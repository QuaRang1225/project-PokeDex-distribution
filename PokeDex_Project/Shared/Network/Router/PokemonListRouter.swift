//
//  PokemonRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import Foundation

/// 포켓몬 리스트 요청 라우터
enum PokemonListRouter: Router {

    /// 포켓몬 리스트요청 (페이지, 지방, 타입1, 타입2, 이름)
    case pokemons(page: Int, region: String, types: Types, query: String)
    
    var baseUrl: URL {
        return URL(string: Config.awsURL)!
    }
    
    var endPoint: String {
        switch self {
        case .pokemons:
            return "/pokemons"
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case let .pokemons(page, region, types, query):
            return [
                "page": "\(page)",
                "region": region,
                "types_1": types.first,
                "types_2": types.last,
                "query": query
            ]
        }
    }
    
    func addQuery(_ url: URL) -> URL {
        switch self {
        case .pokemons:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            guard let composedURL = components?.url else { return url }
            return composedURL
        }
    }
    
    func makeURLRequest() -> URLRequest {
        let url = baseUrl.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: addQuery(url))
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
}
