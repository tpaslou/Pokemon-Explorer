import SwiftUI

struct PokemonDetailView: View {
    
    @EnvironmentObject var vm: ViewModel
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            PokemonView(pokemon: pokemon) // This will show the cached image or load it

            VStack(spacing: 10) {
                // Access cached Pokémon details
                if let pokemonID = vm.pokemonIDs[pokemon.name], let details = vm.pokemonDetailsCache[pokemonID] {
                    Text("**ID**: \(details.id)")
                    Text("**Weight**: \(details.weight)")
                    Text("**Height**: \(details.height)")
                    Text("**HP**: \(details.hp ?? 0)")
                    Text("**Attack**: \(details.attack ?? 0)")        
                    Text("**Defense**: \(details.defense ?? 0)")
                } else {
                    Text("Loading details...")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon)
        .environmentObject(ViewModel())
}
