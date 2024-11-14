import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var vm: ViewModel
    let pokemon: Pokemon
    let dimensions: Double = 140
    
    // The callback to refresh the list when the image is loaded
    var onImageLoaded: (() -> Void)?
    
    private var pokemonID: Int? {
        vm.pokemonIDs[pokemon.name]
    }
    
    var body: some View {
        VStack {
            if let id = pokemonID {
                // Display the image if cached, else show a ProgressView
                if let imageData = vm.imageCache[pokemon.name], let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .clipShape(Circle())
                        .onAppear {
                            
                        }
                } else {
                    ProgressView()
                        .frame(width: dimensions, height: dimensions)
                        .task {
                            // Fetch and cache the image when the view appears
                            await vm.fetchAndCacheImage(for: pokemon.name, id: id)
                            onImageLoaded?()

                        }
                    
                }
            } else {
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
