//
//  ViewModel.swift
//  Pokemon Explorer
//
//  Created by thanos loupas on 11/11/24.
//

import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    
    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetails: DetailedPokemon?
    @Published var searchText = ""
    
    var filteredPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter({
            $0.name.contains(searchText.lowercased())
        })
    }
    
    init() {
        // This could be used for initialization if needed in the future
    }
    
    func getPokemonByType(pokemonType: PokemonType) {
        // Fetch Pokémon by type using PokemonManager
        pokemonManager.getPokemonByType(pokemonType: pokemonType) { data in
            DispatchQueue.main.async {
                //print("Fetched data: \(data)")  // Check the structure of the data
                self.pokemonList = data
            }
        }
    }
    
    func getPokemonID(pokemon: Pokemon, completion: @escaping (Int?) -> Void) {
        // Fetch the details for the given Pokémon
        getDetails(pokemon: pokemon)
        
        // Use a delay to wait for the data to be fetched asynchronously
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust the delay based on how long it takes to fetch the data
            // Return the ID from the fetched details
            if let id = self.pokemonDetails?.id {
                completion(id)
            } else {
                completion(nil)
            }
        }
    }
    
    func getDetails(pokemon: Pokemon) {
        // Directly fetch details by Pokémon name without using ID
        self.pokemonDetails = DetailedPokemon(id: 0, height: 0, weight: 0, stats: [])
        
        pokemonManager.getDetailedPokemon(name: pokemon.name) { data in
            DispatchQueue.main.async {
                self.pokemonDetails = data
            }
        }
    }
    
    func formatStat(value: Int) -> String {
        let dValue = Double(value)
        let string = String(format: "%.2f", dValue / 10)
        return string
    }
}
