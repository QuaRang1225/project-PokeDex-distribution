//
//  EvolutionRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation
import Alamofire

/// 진화 트리 요청 라우터
enum EvolutionRouter: Router {
    
    /// 진화 트리 요청
    case evolutuon(num:Int)
    
    var baseUrl: URL {
        return URL(string: Config.awsURL)!
    }
    
    var endPoint:String{
        switch self{
        case let .evolutuon(num):
            return "/tree/\(num)"
        }
    }
    
    var parameters: [String : String] {
        return [:]
    }
    
    func addQuery(_ url: URL) -> URL? {
        switch self {
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
