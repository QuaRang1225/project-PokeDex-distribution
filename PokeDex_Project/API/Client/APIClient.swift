//
//  APIClient.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//
import Foundation
import Alamofire

final class ApiClient{
    
    var session:Session
    static let shared = ApiClient()
    static let baseURL =  "http://\(Bundle.main.infoDictionary?["LOCAL_URL"] ?? "")"
    
    let monitors = [ApiLogger()] as [EventMonitor]
    
    init(){
        session = Session(eventMonitors: monitors)
    }
    
}
