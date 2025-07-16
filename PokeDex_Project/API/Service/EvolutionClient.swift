//
//  EvolutionApiRouter.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/20/24.
//

import Foundation
import Alamofire
import Combine

struct EvolutionClient {
    static func evolution(num:Int)-> AnyPublisher<EvolutionTreeResponse,AFError>{
        print("포켓몬 진화트리 api 호출")
        return ApiClient.shared.session
            .request(EvolutionRouter.evolutuon(num:num))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: EvolutionTreeResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
}
