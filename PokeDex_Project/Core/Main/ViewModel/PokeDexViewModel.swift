//
//  PokeDexViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/28.
//

import Foundation
import PokemonAPI

class PokeDexViewModel:ObservableObject{
    @Published var model:[Row] = []
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
                                    model.append(Row(num: i.entryNumber ?? 0, image: imageUrl(url: species.id!), name: lang.name!, type: types))
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
