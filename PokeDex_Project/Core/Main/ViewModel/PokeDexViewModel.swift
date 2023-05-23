//
//  PokeDexViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/28.
//

import Foundation
import PokemonAPI
import RealmSwift

class PokeDex:Object,Identifiable{
    @Persisted(primaryKey: true)var id:ObjectId
    
    @Persisted var num:Int
    @Persisted var image:String
    @Persisted var name:String
    @Persisted var types:List<String>
    
    private static var realm = try! Realm()
    
    static func findAll() -> Results<PokeDex> {
            realm.objects(PokeDex.self)
        }
        
        // realm객체에 값을 추가
        static func addMemo(_ memo: PokeDex) {
            try! realm.write {
                realm.add(memo)
            }
        }
        
        // realm객체의 값을 삭제
        static func delMemo(_ memo: PokeDex) {
            try! realm.write {
                realm.delete(memo)
            }
        }
        
        // realm객체의 값을 업데이트
        static func editMemo(memo: PokeDex, title: String, text: String) {
            try! realm.write {
//                memo.title = title
//                memo.text = text
//                memo.postedDate = Date.now
            }
        }
    override class func primaryKey() -> String? {
        "id"
    }
}
class PokeDexViewModel:ObservableObject{
    
    //@ObservedResults(PokeDex.self) var info
    
    @Published var model: [PokeDex] = Array(PokeDex.findAll())
   // @Published var model:[Row] = []
    @Published var location:LocationFilter = .national
    var taskHandle: Task<Void, Error>?
    
    @MainActor
    func get(){
        taskHandle = Task{
            while true {
                let dex = try await PokemonAPI().gameService.fetchPokedex(location.endPoint)
                if let dexEnt =  dex.pokemonEntries{
                    for i in dexEnt{
                       let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies((i.pokemonSpecies?.name)!)
                        if let names = species.names{
                            for lang in names{
                                if lang.language?.name == "ko"{
                                    let types = await getKoreanType(num: species.id!)
                                    if Task.isCancelled {
                                        print("도감정보 바뀜")
                                        break
                                    }
                                    let info = PokeDex()
                                    info.image = imageUrl(url: species.id ?? 0)
                                    info.name = lang.name ?? ""
                                    info.num = i.entryNumber ?? 0
                                    info.types.append(objectsIn: types)
                                    PokeDex.addMemo(info)
                                   // model.append(Row(num: i.entryNumber ?? 0, image: imageUrl(url: species.id!), name: lang.name!, type: types))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func cancelTask() {
        taskHandle?.cancel()
        
    }
    func getKoreanType(num:Int) async -> [String]{    //포켓몬 타입/한글로 변환
        var koreanType = [String]()
        let pokemon = try? await PokemonAPI().pokemonService.fetchPokemon(num)
        if let types = pokemon?.types{
            for type in types {
                let type = try? await PokemonAPI().pokemonService.fetchType(urlToInt(url: (type.type?.url)!))
                koreanType.append(type?.names![1].name ?? "")
            }
        }
        return koreanType
    }
    private func urlToInt(url:String)->Int{
        let url = Int(String(url.filter({$0.isNumber}).dropFirst()))!
        return url
    }
    private func imageUrl(url:Int)->String{ //이미지 url
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"
    }
}
