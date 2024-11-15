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
                        Text("**ID**: \(vm.pokemonIDs[pokemon.name] ?? 0)")
                        Text("**Weight**: \(vm.pokemonDetails?.weight ?? 0)")
                        Text("**Height**: \(vm.pokemonDetails?.height ?? 0)")
                        Text("**HP**: \(vm.pokemonDetails?.hp ?? 0)")
                        Text("**Attack**: \(vm.pokemonDetails?.attack ?? 0)")
                        Text("**Defence**: \(vm.pokemonDetails?.defense ?? 0)")

                        
                    }
                    .padding()
                }
                .onAppear {
                    
                }
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon)
        .environmentObject(ViewModel())
}
