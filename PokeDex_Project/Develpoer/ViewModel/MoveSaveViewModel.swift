//
//  MovieSaveViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/08/19.
//

import Foundation
import PokemonAPI
import FirebaseFirestoreSwift
import FirebaseFirestore


class MoveSaveViewModel:ObservableObject{
    
    
    
    @MainActor
    func getMoveList(num:Int) {
        Task{
            let moveResults = try await PokemonAPI().moveService.fetchMove(num)
            let type = try await PokemonAPI().pokemonService.fetchType(moveResults.type?.name ?? "")
            
            var moveName = ""
            var moveDes = ""
            var damageClass = ""
            
            if let moveListresult = moveResults.names{
                let korName = moveListresult.first(where: {$0.language?.name == "ko"})
                moveName = korName?.name ?? ""
            }
            if let moveDescriptions = moveResults.flavorTextEntries{
                let korDes =  moveDescriptions.first(where: {$0.language?.name == "ko"})
                moveDes = korDes?.flavorText ?? ""
            }
            
            
            
            switch moveResults.damageClass?.name{
            case "physical":
                damageClass = "물리"
            case "special":
                damageClass = "특수"
            case "status":
                damageClass = "변화"
            case .none:
                return
            case .some(_):
                return
            }
            
            let data:[String : Any] = [
                "id":num,
                "name":moveName,
                "description":moveDes,
                "power":moveResults.power ?? 0,
                "pp":moveResults.pp ?? 0,
                "accuracy":moveResults.accuracy ?? 0,
                "type":type.names?.first(where: {$0.language?.name == "ko"})?.name ?? "",
                "damge":damageClass
            ]
            
            try await Firestore.firestore().collection("Move").document("\(num)").setData(data)
        }
    }
    
    
    
    @MainActor
    func getItemList() {
        
        Task{
            let items = try await PokemonAPI().itemService.fetchItemList(paginationState: PaginationState.initial(pageLimit: 2050))
            
            if let results = items.results{
                for result in results {
                    
                    let num = result.url?.urlToInt() ?? 0
                    do{
                        let item = try await PokemonAPI().itemService.fetchItem(num)
                        
                        let data:[String:Any] = [
                            "id":num,
                            "name":item.names?.first(where: {$0.language?.name == "ko"})?.name ?? "",
                            "description":item.flavorTextEntries?.first(where: {$0.language?.name == "ko"})?.text ?? "",
                            "coast":item.cost ?? 0,
                            "sprites":item.sprites?.default ?? ""
                        ]
                        try await Firestore.firestore().collection("Items").document("\(num)").setData(data)
                        
                    }catch{}
                }
            }
            
        }
        
    }
    
    func getMove() async{
        for i in 1...900{
            await getMoveList(num:i)
        }
        for i in 10001...10018{
            await getMoveList(num:i)
        }
    }
}

extension String{
    func urlToInt()->Int{ //포켓몬 이미지를 얻기 위한 url에서 코드 추출
        let url = Int(String(self.filter({$0.isNumber}).dropFirst()))!
        return url
    }
}
