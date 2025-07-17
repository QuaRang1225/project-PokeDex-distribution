//
//  VarietiesRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import Foundation

/// 다른 모습 - (리전폼, 메가진화 등) 요청 라우터
enum VarietiesRouter: Router {
    
    /// 다른 모습 - 영문 이름으로 요청
    case variety(name:String)
    
    var baseUrl: URL {
        return URL(string: Config.awsURL)!
    }
    
    var endPoint:String{
        switch self{
        case let .variety(name):
            return "/variety/\(name)"
        }
    }
    
    var parameters: [String : String] {
        return [:]
    }
    
    func addQuery(_ url: URL) -> URL? {
        return nil
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
