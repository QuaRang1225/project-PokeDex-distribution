//
//  TestView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/04/26.
//
import SwiftUI
import PokemonAPI

struct TestView: View {
    @State private var rotation = 0.0
       
       var body: some View {
           Circle()
                      .stroke(
                          AngularGradient(
                              gradient: Gradient(colors: [Color.white, Color.red]),
                              center: .center,
                              startAngle: .zero,
                              endAngle: .degrees(360)
                          ),
                          lineWidth: 10
                      )
                      .frame(width: 100, height: 100)
                      .rotationEffect(Angle(degrees: rotation))
                      .onAppear {
                          withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                              rotation = 360
                          }
                      }
       }
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

struct Model:Codable{
    var a:String
    var b:Int
}

class ViewModel:ObservableObject{
    @Published var model:[Row] = []
    @Published var location:LocationFilter = .national
    var taskHandle: Task<Void, Error>?
    
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
                                    model.append(Row(dexNum: i.entryNumber ?? 0, num: i.entryNumber ?? 0, image: imageUrl(url: species.id!), name: lang.name!, type: types))
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
