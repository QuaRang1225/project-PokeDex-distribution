//
//  PokeDexViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/28.
//

import Foundation
import PokemonAPI

class PokeDexViewModel:ObservableObject{
    
    @Published var location:LocationFilter = .national
    @Published var dexNum = Array(1...1010)
    @Published var names = String()
    @Published var types = [String]()
    
    
    
    func getLocation()async->[Int]{
        //FireStore.firebas
        var pokemonNum = [Int]()
        let locationNum = try? await PokemonAPI().gameService.fetchPokedex(location.endPoint)
        if let location = locationNum?.pokemonEntries{
            for num in location{
                pokemonNum.append(self.urlToInt(url: num.pokemonSpecies?.url ?? ""))
            }
        }
        return pokemonNum
    }
    
    private func urlToInt(url:String)->Int{ //url 고유아이디로 변환
        let url = Int(String(url.filter({$0.isNumber}).dropFirst()))!
        return url
    }
    func imageUrl(url:Int)->String{ //이미지 url
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(url).png"
    }
    func getKoreanName(num: Int) async -> String {  //포켓몬 이름/한글로 변환
        let species = try? await PokemonAPI().pokemonService.fetchPokemonSpecies(num)
        
        if let name = species?.names, name.count < 3{
            if num == 1009{
                return "굽이치는 물결"
            }else{
                return "무쇠잎새"
            }
        }else if num == 505{
            return "보르그"
        }else{
            return species?.names?[2].name ?? "이름없음"
        }
        
        
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
}
