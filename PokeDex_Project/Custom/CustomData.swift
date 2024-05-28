//
//  CustomData.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/15/24.
//

import Foundation

class CustomData{
    
    static let instance = CustomData()
    private init(){}
    
    var pokemon = Pokemons(id: 271, color: "green", base: Base(image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/271.png", types: ["물","풀"]), captureRate: 120, dex: [Dex(num: 271, region: "전국"),Dex(num: 20, region: "호연(구)"),Dex(num: 56, region: "칼로스 마운틴")], eggGroup: ["수중 1","식물"], evolutionTree: 136, formsSwitchable: false, genderRate: 4, genra: "명랑함포켓몬", hatchCounter: 15, name: "로토스", textEntries: TextEntries(text: [ "햇볕이 잘 드는 물가에 산다.\n낮에는 수초로 된 침대에서\n자고 해가 지면 활동하기 시작한다.","낚시꾼을 발견하면\n물속에서 낚싯줄을 잡아당겨\n방해하며 좋아하는 장난꾸러기다.","해 질 무렵이 되면 활동하는 야행성이다.\n낚시꾼을 발견하면 물속에서 줄을\n당겨 방해하고선 기뻐한다.","몸 전체가 미끈미끈한 점액으로 덮여 있어서\n그 손에 닿으면 매우 기분 나쁘다.\n곧잘 인간의 아이로 오인된다.","해질녘이 되면 활동을\n시작하는 야행성 포켓몬이다.\n강바닥의 이끼를 먹는다.","햇볕이 잘 드는 물가에 산다.\n낮에는 수초로 된 침대에서 자고\n해가 지면 활동하기 시작한다."], version: [ "X","Y","오메가루비","알파사파이어","소드","실드"]), varieties: ["lombre"])
    var pokemonList = [
        PokemonsList(id: 1, color: "green", name: "이상해씨", base: ListBase(image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png", types: ["독","풀"], num: 1)),
        PokemonsList(id: 2, color: "green", name: "이상해풀", base: ListBase(image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/2.png", types: ["독","풀"], num: 2)),
        PokemonsList(id: 3, color: "green", name: "이상해꽃", base: ListBase(image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/3.png", types: ["독","풀"], num: 3))
    ]
}
