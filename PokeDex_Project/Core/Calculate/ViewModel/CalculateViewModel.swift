//
//  CalculateViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/06/23.
//

import Foundation

class CalculateViewModel:ObservableObject{
    
    @Published var calculate:Calculate = .attack
    
    func indicatorOffset(width:CGFloat)->CGFloat{
        let index = CGFloat(getIndex())
        if index == 0{return 0}
        let buttonWidth = width/CGFloat(Calculate.allCases.count)
        
        return index * buttonWidth
        
    }
    func getIndex() ->Int{
        switch calculate{
        case .attack:
            return 0
        case .defense:
            return 1
        }
    }
    
    enum Calculate:CaseIterable{
        case attack
        case defense
        
        var name:String{
            switch self{
            case .attack:
                return "결정력"
            case .defense:
                return "내구력"
            }
        }
    }
}
