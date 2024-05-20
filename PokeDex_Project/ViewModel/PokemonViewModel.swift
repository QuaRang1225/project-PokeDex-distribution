//
//  PokemonViewModel.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/10/24.
//

import Foundation
import Combine

class PokemonViewModel:ObservableObject{
    
    var cancelable = Set<AnyCancellable>()
    @Published var pokemon:Pokemons? = nil
    @Published var variety:Varieties? = nil
    @Published var evolutionTree:EvolutionTo? = nil
    @Published var varieties:[Varieties] = []
    @Published var pokemonList:[PokemonsList] = []
    @Published var formList:[String] = []
    
    @Published var currentPage = 1
    @Published var maxPage = 0
    
    init(pokemonList:[PokemonsList],pokemon:Pokemons?){
        self.pokemon = pokemon
        self.pokemonList = pokemonList
    }
    
    func fetchPokemon(id:Int){
        PokemonApiService.pokemon(id: id)
            .sink {completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print(completion)
                }
            } receiveValue: { [weak self] data in
                self?.pokemon = data.data
                self?.fetchEvolution(num: data.data.evolutionTree)
                data.data.varieties.forEach { variety in
                    self?.fetchVariety(name: variety)
                }
            }.store(in: &cancelable)
    }
    func fetchPokemonList(page:Int,region:String,type_1:String,type_2:String,query:String){
        PokemonApiService.pokemons(page:page,region:region,type_1:type_1,type_2:type_2,query:query)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print(completion)
                }
                self.currentPage = page
            } receiveValue: { [weak self] data in
                self?.pokemonList.append(contentsOf: data.data.pokemon)
                self?.maxPage = data.data.totalPages
            }.store(in: &cancelable)
    }
    private func fetchVariety(name:String){
        VarietiesApiService.variety(name: name)
            .sink {completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    self.variety = self.varieties[0]
                    self.variety?.form.id.sort()
                    self.formList = self.variety?.form.images ?? []
                    print(completion)
                }
            } receiveValue: { [weak self] data in
                self?.varieties.append(data.data)
            }.store(in: &cancelable)
    }
    private func fetchEvolution(num:Int){
        EvolutionApiService.evolution(num: num)
            .sink {completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print(completion)
                }
            } receiveValue: { [weak self] data in
                self?.evolutionTree = data.data
            }.store(in: &cancelable)
    }
}
