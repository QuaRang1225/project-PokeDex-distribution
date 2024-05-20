//
//  VarietiesApiService.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/17/24.
//

import Foundation
import Alamofire
import Combine

enum VarietiesApiService{
    static func variety(name:String)-> AnyPublisher<VarietiesRespons,AFError>{
        print("포켓몬 폼 api 호출")
        return ApiClient.shared.session
            .request(VarietiesRouter.variety(name:name))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: VarietiesRespons.self)
            .value()
            .eraseToAnyPublisher()
    }
}
