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
                        Text("**ID**: \(vm.pokemonDetails?.id ?? 0)")
                        /*Text("**Weight**: \(vm.formatHW(value: vm.pokemonDetails?.weight ?? 0)) KG")
                        Text("**Height**: \(vm.formatHW(value: vm.pokemonDetails?.height ?? 0)) M")*/
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
