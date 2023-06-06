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

class PokeDex: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var num: Int
    @Persisted var image: String
    @Persisted var name: String
    @Persisted var types: List<String>
//    @Persisted var dex: List<String>

    private static var realm = try! Realm()
    static var currentPokeDex: Results<PokeDex>?

    static func findAll() -> Results<PokeDex> {
        if let currentPokeDex = currentPokeDex {
            return currentPokeDex
        }
        return realm.objects(PokeDex.self)
    }

    // realm 객체에 값을 추가
    static func addMemo(_ memo: PokeDex) {
        try! realm.write {
            realm.add(memo)
            currentPokeDex = nil
        }
    }

//    static func editMemo(memo: PokeDex, location: String, num: Int) {
//        try! realm.write {
//            memo.dex.append("\(location) : \(num)")
//        }
//    }

    static func applicationWillTerminate() {
        currentPokeDex = realm.objects(PokeDex.self)
    }

    static func deleteAll() {
        let objectsToDelete = realm.objects(PokeDex.self)

        do {
            try realm.write {
                realm.delete(objectsToDelete)
            }
            currentPokeDex = nil
        } catch {
            print("Error deleting all objects: \(error)")
        }
    }

    override class func primaryKey() -> String? {
        "id"
    }
}

class PokeDexViewModel: ObservableObject {
    //@ObservedResults(PokeDex.self) var info
    private var notificationToken: NotificationToken?
    @Published var model: [PokeDex] = Array(PokeDex.findAll())
    @Published var successDownload = false
    @Published var pokeDexCount: Int = 0
    @Published var location: LocationFilter = .national

    var taskHandle: Task<Void, Error>?

    init() {
        fetchData()
        observeChanges()
    }

    private func fetchData() {
        let pokeDex = PokeDex.findAll()
        pokeDexCount = pokeDex.count
        if pokeDexCount == 1010 {
            successDownload = true
            print(successDownload)
        }
    }

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
        taskHandle = Task {
            let dex = try await PokemonAPI().gameService.fetchPokedex(location.endPoint)
            if let dexEnt = dex.pokemonEntries {
                await withTaskGroup(of: Void.self) { group in
                    for i in dexEnt {
                        group.addTask {
                            do {
                                let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(i.pokemonSpecies!.name!)
                                if let names = species.names {
                                    let info = PokeDex()

                                    for lang in names {
                                        if lang.language?.name == "ko" {
                                            let types = await self.getKoreanType(num: species.id!)
                                            info.image = self.imageUrl(url: species.id ?? 0)
                                            info.name = lang.name ?? ""
                                            info.num = i.entryNumber ?? 0
                                            info.types.append(objectsIn: types)
//                                            info.dex.append(objectsIn: types)
                                            DispatchQueue.main.async {
                                                PokeDex.addMemo(info)
                                            }
                                        }
                                    }

//                                    if let dexNum = species.pokedexNumbers {
//                                        for num in dexNum {
//                                            for i in LocationFilter.allCases {
//                                                if num.name?.name == i.apiName {
//                                                    info.dex.append("\(i.apiName) : \(num.entryNumber ?? 0)")
//                                                }
//                                            }
//                                        }
//                                    }
//                                    DispatchQueue.main.async {
//                                        PokeDex.addMemo(info)
////                                        PokeDex.editMemo(memo: info, location: i.apiName, num: num.entryNumber ?? 0)
//                                    }
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

    func getKoreanType(num: Int) async -> [String] {    // 포켓몬 타입/한글로 변환
        var koreanType = [String]()
        let pokemon = try? await PokemonAPI().pokemonService.fetchPokemon(num)
        if let types = pokemon?.types {
            for type in types {
                let type = try? await PokemonAPI().pokemonService.fetchType(urlToInt(url: (type.type?.url)!))
                koreanType.append(type?.names![1].name ?? "")
            }
        }
        return koreanType
    }

    private func urlToInt(url: String) -> Int {
        let url = Int(String(url.filter({ $0.isNumber }).dropFirst()))!
        return url
    }

    private func imageUrl(url: Int) -> String { // 이미지 URL
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"
    }
}
