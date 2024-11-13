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
    
    // Dictionary to store IDs by Pokemon name for later reference
    var pokemonIDs: [String: Int] = [:]
    
    var filteredPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter({
            $0.name.contains(searchText.lowercased())
        })
    }
    
    func getPokemonByType(pokemonType: PokemonType) {
        pokemonManager.getPokemonByType(pokemonType: pokemonType) { data in
            DispatchQueue.main.async {
                self.pokemonList = data
                
                // For each Pokemon, fetch its ID and store it
                for pokemon in data {
                    self.getPokemonID(pokemon: pokemon) { id in
                        if let id = id {
                            self.pokemonIDs[pokemon.name] = id
                        }
                    }
                }
            }
        }
    }
    
    func getPokemonID(pokemon: Pokemon, completion: @escaping (Int?) -> Void) {
        // Check if ID is already cached
        if let cachedID = pokemonIDs[pokemon.name] {
            completion(cachedID)  // Return cached ID
        } else {
            // Fetch details if not cached
            getDetails(pokemon: pokemon) { [weak self] details in
                guard let self = self, let id = details?.id else {
                    completion(nil)
                    return
                }
                self.pokemonIDs[pokemon.name] = id  // Cache the ID
                completion(id)  // Return the fetched ID
            }
        }
    }

    func getDetails(pokemon: Pokemon, completion: @escaping (DetailedPokemon?) -> Void) {
        pokemonManager.getDetailedPokemon(name: pokemon.name) { data in
            DispatchQueue.main.async {
                self.pokemonDetails = data  // Update `pokemonDetails` for current access
                completion(data)  // Return the fetched details
            }
        }
    }
}
