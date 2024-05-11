//
//  APILogger.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import Foundation

import Alamofire

final class ApiLogger:EventMonitor{
    
    let queue = DispatchQueue(label:"Imad")
    
    func requestDidResume(_ request: Request) {
        print("Api resume.. : \(request)")
    }
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        print("Api end.. : \(response.result)")
    }
}
