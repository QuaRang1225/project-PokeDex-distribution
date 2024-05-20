//
//  EvolutionRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation
import Alamofire

enum EvolutionRouter:URLRequestConvertible{
    case evolutuon(num:Int)
    
    var baseUrl:URL{
        return URL(string:ApiClient.baseURL)!
    }
    var endPoint:String{
        switch self{
        case let .evolutuon(num):
            return "/tree/\(num)"
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = baseUrl.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = .get
        return try URLEncoding.queryString.encode(request, with: Parameters())
                                                  
    }
}
