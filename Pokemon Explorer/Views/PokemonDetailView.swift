//
//  PokemonDetailView.swift
//  Pokemon Explorer
//
//  Created by thanos loupas on 11/11/24.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @EnvironmentObject var vm: ViewModel
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            PokemonView(pokemon: pokemon)
            
            VStack(spacing: 10) {
                // Access cached Pokémon details
                if let pokemonID = vm.pokemonIDs[pokemon.name], let details = vm.pokemonDetailsCache[pokemonID] {
                    Text("**ID**: \(details.id)")
                    Text("**Weight**: \(details.weight)")
                    Text("**Height**: \(details.height)")
                    Text("**HP**: \(details.hp)")
                    Text("**Attack**: \(details.attack)")
                    Text("**Defense**: \(details.defense)")
                } else {
                    Text("Loading details...")
                        .foregroundColor(.gray)
                    
                }
            }
            .padding()
        }
        .onAppear {
            // Fetch and cache details when the view appears
            //vm.fetchAndCacheDetails(for: pokemon)
        }
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon)
        .environmentObject(ViewModel())
}
