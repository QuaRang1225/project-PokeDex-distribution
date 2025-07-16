//
//  PokemonApiService.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import Foundation
import Alamofire
import Combine

enum PokemonAPIService {
    static func pokemon(id:Int) -> AnyPublisher<PokemonResponse,AFError>{
        print("포켓몬 api 호출")
        return ApiClient.shared.session
            .request(PokemonRouter.pokemon(id: id))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: PokemonResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func pokemons(page:Int,region:String,type_1:String,type_2:String,query:String)-> AnyPublisher<PokemonListResponse,AFError>{
        print("포켓몬 api 호출")
        return ApiClient.shared.session
            .request(PokemonRouter.pokemons(page: page, region: region, type_1: type_1, type_2: type_2, query: query))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: PokemonListResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
}
