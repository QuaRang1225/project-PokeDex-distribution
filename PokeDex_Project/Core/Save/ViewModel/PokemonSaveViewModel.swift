//
//  PokemonSaveViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/06/21.
//

import Foundation
import RealmSwift
import SwiftUI

//class Saving:Object,Identifiable{
//
//    @objc dynamic var id:Date = Date()
//    @objc dynamic var num: Int = 0
//    @objc dynamic var image: String = ""
//    @objc dynamic var name: String = ""
//    @objc dynamic var types:[String] = []
//
//
//
//}

class SaveViewModel:ObservableObject{
    @Published var num:Int = 0
    @Published var image:String = ""
    @Published var name:String = ""
    @Published var types:[String] = []
    
    @Published var save:[Save] = []
    
    init(){
        fetchData()
    }
    func fetchData(){
        guard let db = try? Realm() else{return}
        let result = db.objects(Save.self)
        self.save = result.compactMap({ (dard) -> Save? in
            return dard
        })
    }
    func addData(){
        let save = Save()
        save.num = num
        save.image = image
        save.name = name
        save.types.append(objectsIn: types)
        guard let dbRef = try? Realm() else {return}
        try? dbRef.write{
            dbRef.add(save)
            fetchData()
        }
    }
    func deleteData(save:Save){
        guard let dbRef = try? Realm() else {return}
        try? dbRef.write{
            dbRef.delete(save)
        }
        
        fetchData()
    }
   
    
}



//class MySave: Object, Identifiable {
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var num: Int
//    @Persisted var image: String
//    @Persisted var name: String
//    @Persisted var types: List<String>
//
//    private static var realm = try! Realm()
////    static var currentPokeDex: Results<MySave>?
//
//    static func findAll() -> Results<MySave> {
//        guard let dbRef = try? Realm() else {return}
//        let results = dbRef.objects(MySave.self)
//
//        results.compactMap({ (mySave) -> MySave in
//             return  mySave
//        })
////        if let currentPokeDex = currentPokeDex {
////            return currentPokeDex
////        }
////        return realm.objects(MySave.self)
//    }
//
//    // realm 객체에 값을 추가
//    static func addMemo(_ memo: MySave) {
//        try! realm.write {
//            realm.add(memo)
////            currentPokeDex = nil
//        }
//    }
//
////    static func applicationWillTerminate() {
////        currentPokeDex = realm.objects(MySave.self)
////    }
//
////    static func deleteAll() {
////        let objectsToDelete = realm.objects(MySave.self)
////
////        do {
////            try realm.write {
////                realm.delete(objectsToDelete)
////            }
////            currentPokeDex = nil
////        } catch {
////            print("Error deleting all objects: \(error)")
////        }
////    }
//    static func delMemo(_ data: MySave) {
//        do {
//            try realm.write {
//                realm.delete(data)
//            }
////            currentPokeDex = nil
//        } catch {
//            print("Error deleting all objects: \(error)")
//        }
//    }
//
//    override class func primaryKey() -> String? {
//        "id"
//    }
//}
//class PokemonSaveViewModel:ObservableObject{
//
//    @Published var savelist:[MySave] = Array(MySave.findAll())
////    @Published var array:[Row] = []
////    @Published var data:MySave? = nil
//
//    func save(num:Int,image:String,name:String,types:[String]){
//        let db = MySave()
//        db.name = name
//        db.image = image
//        db.types.append(objectsIn: types)
//        db.num = num
//        DispatchQueue.main.async {
//            MySave.addMemo(db)
//        }
//    }
//
//    func refresh(){
//        self.savelist = Array(MySave.findAll())
//    }
//    func fetchData(){
//        let
//    }
//
////    func saveArray(){
////        array.removeAll()
////        self.refresh()
////        for i in savelist{
////            array.append(Row(dexNum: i.num, num: i.num, image: i.image, name: i.name, type: Array(i.types)))
////        }
////    }
//}
