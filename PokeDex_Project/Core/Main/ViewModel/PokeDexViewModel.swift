//
//  PokeDexViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/28.
//

import Foundation
import PokemonAPI
import Combine

class PokeDexViewModel:ObservableObject{
    
    @Published var location:LocationFilter = .national
    @Published var dexNum = Array(1...1010)
    @Published var row = Row(num: 1, image:"", name: "", type: [])
    
    var dexNumSuccess = PassthroughSubject<[Int],Never>()
    

    
    func getLocation()async->[Int]{
        var pokemonNum = [Int]()
        let locationNum = try? await PokemonAPI().gameService.fetchPokedex(location.endPoint)
        if let location = locationNum?.pokemonEntries{
            for num in location{
                pokemonNum.append(self.urlToInt(url: num.pokemonSpecies?.url ?? ""))
            }
        }
        return pokemonNum
    }
    func getRowInfo(num:Int){
        row.num = num
        row.image = imageUrl(url: num)
        //let name = try await PokemonAPI().pokemonService.fetchPokemon(num)
        
    }
    
    private func urlToInt(url:String)->Int{ //url 고유아이디로 변환
        let url = Int(String(url.filter({$0.isNumber}).dropFirst()))!
        return url
    }
    func imageUrl(url:Int)->String{ //이미지 url
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"
    }
    private func getKoreanName(name: String) async -> String {  //포켓몬 이름 한글로 변환
        let name = try? await PokemonAPI().pokemonService.fetchPokemonSpecies(name)
        return name?.names![2].name ?? ""
    }
    private func getKoreanType(type:String) async -> String{    //포켓몬 타입 한글로 변환
        let type = try? await PokemonAPI().pokemonService.fetchType(type)
        return type?.names![1].name ?? ""
    }
}
