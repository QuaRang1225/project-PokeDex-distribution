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
    
    
    @Persisted var image: String
    @Persisted var name: String
    @Persisted var types: List<String>
    
    @Persisted var national: Int
    @Persisted var kanto:Int?
    @Persisted var johto:Int?
    @Persisted var hoenn:Int?
    @Persisted var sinnoh:Int?
    @Persisted var unova:Int?
    @Persisted var kalos_ctl:Int?
    @Persisted var kalos_cst:Int?
    @Persisted var kalos_mtn:Int?
    @Persisted var alaola:Int?
    @Persisted var galar:Int?
    @Persisted var paldea:Int?
    
    

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

    private var notificationToken: NotificationToken?
    @Published var model: [PokeDex] = Array(PokeDex.findAll())
    @Published var successDownload = false
    @Published var pokeDexCount: Int = 0
    @Published var location: LocationFilter = .national
    
    @Published var array:[Row] = []


    var taskHandle: Task<Void, Error>?

    init() {
        fetchData()
        observeChanges()
    }
    func dexNum(){
        
        
        array.removeAll()
        
        switch location {
        case .national:
            for i in model{
                array.append(Row(dexNum: i.national, num: i.national, image: i.image, name: i.name, type: Array(i.types)))
                print(i.national)
            }
        case .kanto:
            for i in model{
                if let kanto = i.kanto{
                    array.append(Row(dexNum: i.national,num: kanto, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .johto:
            for i in model{
                if let johto = i.johto{
                    array.append(Row(dexNum: i.national,num: johto, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .hoenn:
            for i in model{
                if let hoenn = i.hoenn{
                    array.append(Row(dexNum: i.national,num: hoenn, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .sinnoh:
            for i in model{
                if let sinnoh = i.sinnoh{
                    array.append(Row(dexNum: i.national,num: sinnoh, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .unova:
            for i in model{
                if let unova = i.unova{
                    array.append(Row(dexNum: i.national,num: unova, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .kalos_ctl:
            for i in model{
                if let kalos_ctl = i.kalos_ctl{
                    array.append(Row(dexNum: i.national,num: kalos_ctl, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .kalos_cst:
            for i in model{
                if let kalos_cst = i.kalos_cst{
                    array.append(Row(dexNum: i.national,num: kalos_cst, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .kalos_mtn:
            for i in model{
                if let kalos_mtn = i.kalos_mtn{
                    array.append(Row(dexNum: i.national,num: kalos_mtn, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .alaola:
            for i in model{
                if let alaola = i.alaola{
                    array.append(Row(dexNum: i.national,num: alaola, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .galar:
            for i in model{
                if let galar = i.galar{
                    array.append(Row(dexNum: i.national,num: galar, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        case .paldea:
            for i in model{
                if let paldea = i.paldea{
                    array.append(Row(dexNum: i.national,num: paldea, image: i.image, name: i.name, type: Array(i.types)))
                }
            }
        }
        array.sort(by: {$0.num < $1.num})
    }

    
    private func fetchData() {
        let pokeDex = PokeDex.findAll()
        pokeDexCount = pokeDex.count
        if pokeDexCount == 1010 {
            successDownload = true
            model = Array(PokeDex.findAll())    //빌드 5 이거 추가
        }
    }

    private func observeChanges() {
            let pokeDex = PokeDex.findAll()
            notificationToken = pokeDex.observe { [weak self] _ in
                DispatchQueue.main.async { [weak self] in
                    self?.fetchData()
                }
            }
        }

    func get() {
        taskHandle = Task {
            let dex = try await PokemonAPI().gameService.fetchPokedex(1)
            if let dexEnt = dex.pokemonEntries {
                await withTaskGroup(of: Void.self) { group in
                    for ent in dexEnt {
                        group.addTask {
                            do {
                                let species = try await PokemonAPI().pokemonService.fetchPokemonSpecies(ent.pokemonSpecies!.name!)
                                
                                if let names = species.names {
                                    let info = PokeDex()
                                    for lang in names {
                                        if lang.language?.name == "ko" {
                                            let types = await self.getKoreanType(num: species.id!)
                                            info.image = self.imageUrl(url: species.id ?? 0)
                                            info.name = lang.name ?? ""
                                            info.national = ent.entryNumber ?? 0
                                            info.types.append(objectsIn: types)
                                            for i in LocationFilter.allCases{
                                                let dexNum = try await PokemonAPI().gameService.fetchPokedex(i.endPoint)
                                                if let entries = dexNum.pokemonEntries{
                                                    for num in entries{
                                                        if ent.entryNumber == self.urlToInt(url: num.pokemonSpecies?.url ?? ""){
                                                            switch i{
                                                            case .national:
                                                                info.national = num.entryNumber ?? 0
                                                            case .kanto:
                                                                info.kanto = num.entryNumber ?? 0
                                                            case .johto:
                                                                info.johto = num.entryNumber ?? 0
                                                            case .hoenn:
                                                                info.hoenn = num.entryNumber ?? 0
                                                            case .sinnoh:
                                                                info.sinnoh = num.entryNumber ?? 0
                                                            case .unova:
                                                                info.unova = num.entryNumber ?? 0
                                                            case .kalos_ctl:
                                                                info.kalos_ctl = num.entryNumber ?? 0
                                                            case .kalos_cst:
                                                                info.kalos_cst = num.entryNumber ?? 0
                                                            case .kalos_mtn:
                                                                info.kalos_mtn = num.entryNumber ?? 0
                                                            case .alaola:
                                                                info.alaola = num.entryNumber ?? 0
                                                            case .galar:
                                                                info.galar = num.entryNumber ?? 0
                                                            case .paldea:
                                                                info.paldea = num.entryNumber ?? 0
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            DispatchQueue.main.async {
                                                PokeDex.addMemo(info)
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
