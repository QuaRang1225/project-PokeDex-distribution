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
    @Published var pokemonList:[PokemonsList] = []
    
    @Published var currentPage = 1
    @Published var maxPage = 0
    
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
}
