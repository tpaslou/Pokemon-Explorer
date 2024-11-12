import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var vm: ViewModel
    let pokemon: Pokemon
    let dimensions: Double = 140
    @State private var pokemonID: Int? // Store the ID of the Pokémon
    
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
                ProgressView() // Show progress while fetching the ID
                    .frame(width: dimensions, height: dimensions)
            }

            Text(pokemon.name.capitalized)
                .font(.system(size: 16, weight: .regular, design: .monospaced))
                .padding(.bottom, 20)
        }
        .onAppear {
            // Fetch the Pokémon ID and update the pokemonID state
            vm.getPokemonID(pokemon: pokemon) { id in
                self.pokemonID = id
            }
        }
    }
}
#Preview {
    PokemonView(pokemon: Pokemon.samplePokemon)
        .environmentObject(ViewModel())
}
