import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var vm: ViewModel
    let pokemon: Pokemon
    let dimensions: Double = 140
    
    private var pokemonID: Int? {
        vm.pokemonIDs[pokemon.name]
    }
    
    @State private var isImageLoaded = false  // Track if image is loaded
    
    var body: some View {
        VStack {
            if let id = pokemonID {
                // Display the image if cached, else show a ProgressView
                if let imageData = vm.imageCache[pokemon.name], let image = UIImage(data: imageData), isImageLoaded {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .clipShape(Circle())
                } else {
                    ProgressView()
                        .frame(width: dimensions, height: dimensions)
                        .task {
                            // Fetch and cache the image when the view appears
                            await vm.fetchAndCacheImage(for: pokemon.name, id: id)
                            // Once the image is fetched, update the state to refresh the view
                            DispatchQueue.main.async {
                                isImageLoaded = true
                            }
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
        .onChange(of: vm.imageCache[pokemon.name]) { _ in
            // If the image cache is updated, trigger a view refresh
            isImageLoaded = true
        }
    }
}

#Preview {
    PokemonView(pokemon: Pokemon.samplePokemon)
        .environmentObject(ViewModel())
}
