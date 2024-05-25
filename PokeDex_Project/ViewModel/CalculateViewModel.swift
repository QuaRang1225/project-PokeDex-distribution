//
//  CalculateViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/23/24.
//

import Foundation

class CalculateViewModel:ObservableObject{
    
    @Published var calculate:CalculateFilter = .attack
    
    func indicatorOffset(width:CGFloat)->CGFloat{
        let index = CGFloat(getIndex())
        if index == 0{return 0}
        let buttonWidth = width/CGFloat(CalculateFilter.allCases.count)
        
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
}



