//
//  Router.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/16/25.
//

import Foundation

/// 라우터 인터페이스
protocol Router {
    var baseUrl: URL { get }
    var endPoint: String { get }
    var parameters: [String: String] { get }
    func addQuery(_ url: URL) -> URL?
    func makeURLRequest() -> URLRequest?
}
