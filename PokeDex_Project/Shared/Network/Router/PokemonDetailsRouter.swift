//
//  EvolutionRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation

/// 진화 트리 요청 라우터
enum PokemonDetailsRouter: Router {
    
    /// 단일 요청 - 전국도감 번호로 요청
    case pokemon(id: Int)
    /// 진화 트리 요청
    case evolutuon(num:Int)
    /// 다른 모습 - 영문 이름으로 요청
    case variety(name:String)
    
    var baseUrl: URL {
        return URL(string: Config.awsURL)!
    }
    
    var endPoint:String{
        switch self{
        case let .pokemon(id):
            return "/pokemon/\(id)"
        case let .evolutuon(num):
            return "/tree/\(num)"
        case let .variety(name):
            return "/variety/\(name)"
        }
    }
    
    var parameters: [String : String] {
        return [:]
    }
    
    func addQuery(_ url: URL) -> URL {
        return url
    }
    
    func makeURLRequest() -> URLRequest {
        let url = baseUrl.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: addQuery(url))
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
}
