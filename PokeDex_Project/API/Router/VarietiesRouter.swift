//
//  VarietiesRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import Foundation
import Alamofire

enum VarietiesRouter:URLRequestConvertible{
    case variety(name:String)
    
    var baseUrl:URL{
        return URL(string:ApiClient.baseURL)!
    }
    var endPoint:String{
        switch self{
        case let .variety(name):
            return "/variety/\(name)"
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = baseUrl.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = .get
        return try URLEncoding.queryString.encode(request, with: Parameters())
                                                  
    }
}
