//
//  APIClient.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import Alamofire

final class ApiClient{
    
    var session:Session
    static let shared = ApiClient()
    static let baseURL =  "https://\(Bundle.main.infoDictionary?["AWS_URL"] ?? "")"
    
    let monitors = [ApiLogger()] as [EventMonitor]
    
    init(){
        session = Session(eventMonitors: monitors)
    }
    
}
