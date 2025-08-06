//
//  TabFilter.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/19/25.
//

import Foundation

/// 탭바 필터
enum TabFilter {
    case home, my
    
    var name: String {
        switch self {
        case .home: "도감"
        case .my: "북마크"
        }
    }
    
    var image: String {
        switch self {
        case .home: "book.closed.fill"
        case .my: "bookmark"
        }
    }
}
