import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var vm: ViewModel
    let pokemon: Pokemon
    let dimensions: Double = 140
    
    // Retrieve the Pokémon ID from ViewModel's cached IDs dictionary
    private var pokemonID: Int? {
        vm.pokemonIDs[pokemon.name]
    }
    
    var body: some View {
        VStack {
            // Display the Pokémon image based on the Pokémon ID
            if let id = pokemonID {
                AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: dimensions, height: dimensions)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: dimensions, height: dimensions)
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "exclamationmark.triangle.fill")
                            .frame(width: dimensions, height: dimensions)
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Placeholder if ID is not available
                ProgressView()
                    .frame(width: dimensions, height: dimensions)
            }

            Text(pokemon.name.capitalized)
                .font(.system(size: 16, weight: .regular, design: .monospaced))
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    PokemonView(pokemon: Pokemon.samplePokemon)
        .environmentObject(ViewModel())
}
