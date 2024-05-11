//
//  PokemonRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import Foundation
import Alamofire

enum PokemonRouter:URLRequestConvertible{
    
    case pokemon(id:Int)
    case pokemons(page:Int,region:String,type_1:String,type_2:String,query:String)
    
    var baseUrl:URL{
        return URL(string:ApiClient.baseURL)!
    }
    var endPoint:String{
        switch self{
        case let .pokemon(id):
            return "/pokemon/\(id)"
        case .pokemons:
            return "/pokemons"
        }
    }
    var method:HTTPMethod{
        return .get
    }
    var parameters:Parameters{
        switch self{
        case .pokemon:
            return Parameters()
        case let .pokemons(page, region, type_1, type_2, query):
            var params = Parameters()
            params["page"] = page
            params["region"] = region
            params["type_1"] = type_1
            params["type_2"] = type_2
            params["query"] = query
            return params
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = baseUrl.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        switch self{
        case .pokemon:
            return request
        case .pokemons:
            return try URLEncoding(destination: .queryString).encode(request, with: parameters)
        }
    }
}
