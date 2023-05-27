//
//  PokeDexViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/28.
//

import Foundation
import PokemonAPI
import RealmSwift
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        PokeDex.applicationWillTerminate()
    }
}

class PokeDex:Object,Identifiable{
    @Persisted(primaryKey: true)var id:ObjectId
    
    @Persisted var num:Int
    @Persisted var image:String
    @Persisted var name:String
    @Persisted var types:List<String>
    
    private static var realm = try! Realm()
    static var currentPokeDex: Results<PokeDex>?
    
    static func findAll() -> Results<PokeDex> {
        if let currentPokeDex = currentPokeDex {
            return currentPokeDex
        }
        return realm.objects(PokeDex.self)
    }
    
    // realm객체에 값을 추가
    static func addMemo(_ memo: PokeDex) {
            try! realm.write {
                realm.add(memo)
                currentPokeDex = nil
            }
        }
    
    // realm객체의 값을 삭제
    static func delMemo(_ memo: PokeDex) {
            try! realm.write {
                realm.delete(memo)
                currentPokeDex = nil
            }
        }
    static func applicationWillTerminate() {
            currentPokeDex = realm.objects(PokeDex.self)
        }
    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
            currentPokeDex = nil
        } catch {
            print("Error deleting all objects: \(error)")
            // 예외 처리를 진행하거나 로그를 남기는 등의 작업을 수행할 수 있습니다.
        }
    }

    
    
//     realm객체의 값을 업데이트
//            static func editMemo(memo: PokeDex, title: String, text: String) {
//                try! realm.write {
//    //                memo.title = title
//    //                memo.text = text
//    //                memo.postedDate = Date.now
//                }
//            }
    override class func primaryKey() -> String? {
        "id"
    }
}
class PokeDexViewModel:ObservableObject{
    
    //@ObservedResults(PokeDex.self) var info
    private var notificationToken: NotificationToken?
    
    @Published var model: [PokeDex] = Array(PokeDex.findAll())
    // @Published var model:[Row] = []
    @Published var successDownload = false
    @Published var pokeDexCount: Int = 0
    @Published var location:LocationFilter = .national
    
    var taskHandle: Task<Void, Error>?
    
    init(){
        fetchData()
        observeChanges()
    }

//    deinit {
//        notificationToken?.invalidate()
//    }
//
    private func fetchData() {
        let pokeDex = PokeDex.findAll()
        pokeDexCount = pokeDex.count
        if pokeDexCount == 1010 {
            successDownload = true
            print(successDownload)
        }
        //print(pokeDexCount)
    }

//
    private func observeChanges() {
        let pokeDex = PokeDex.findAll()
        notificationToken = pokeDex.observe { [weak self] _ in
            self?.fetchData()
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }
    }

    func get() {
       taskHandle =  Task {
            let dex = try await PokemonAPI().gameService.fetchPokedex(location.endPoint)
            if let dexEnt = dex.pokemonEntries {
                await withTaskGroup(of: Void.self) { group in
                    for i in dexEnt {
                        group.addTask {
                            do {
                                let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(i.pokemonSpecies!.name!)
                                if let names = species.names {
                                    for lang in names {
                                        if lang.language?.name == "ko" {
                                            let types = await self.getKoreanType(num: species.id!)
                                            let info = PokeDex()
                                            info.image = self.imageUrl(url: species.id ?? 0)
                                            info.name = lang.name ?? ""
                                            info.num = i.entryNumber ?? 0
                                            info.types.append(objectsIn: types)
                                            DispatchQueue.main.async {
                                                PokeDex.addMemo(info)
//                                                let pokeDex = PokeDex.findAll()
//                                                self.pokeDexCount = pokeDex.count
//                                                print(self.pokeDexCount)
                                            }
                                        }
                                    }
                                }
                            } catch {
                                // 에러 처리
                            }
                        }
                    }
                    for await _ in group {
                        // 작업이 완료될 때까지 대기
                    }
                }
            }
        }
    }
//    func cancalTask(){
//        taskHandle?.cancel()
//    }

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
