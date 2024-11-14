import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    
    @Published var pokemonList = [Pokemon]()
    @Published var searchText = ""
    private let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    // Dictionary to store IDs, images, and detailed info by Pokémon name and ID
    var pokemonIDs: [String: Int] = [:]
    var imageCache: [String: Data] = [:]
    var pokemonDetailsCache: [Int: DetailedPokemon] = [:] // Cache for Pokémon details
    
    // Computed property for filtering Pokémon based on search text
    var filteredPokemon: [Pokemon] {
        return searchText.isEmpty ? pokemonList : pokemonList.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    init() {
        loadCachedData()
    }
    
    // Load cached data for IDs, images, and detailed Pokémon information
    private func loadCachedData() {
        // Load cached Pokémon IDs
        let idsURL = cacheDirectory.appendingPathComponent("pokemonIDs.json")
        if let data = try? Data(contentsOf: idsURL),
           let cachedIDs = try? JSONDecoder().decode([String: Int].self, from: data) {
            self.pokemonIDs = cachedIDs
        }
        
        // Load cached images
        let imageCacheURL = cacheDirectory.appendingPathComponent("imageCache")
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: imageCacheURL.path) {
            for imageName in contents {
                let imageURL = imageCacheURL.appendingPathComponent(imageName)
                if let data = try? Data(contentsOf: imageURL) {
                    imageCache[imageName] = data
                }
            }
        }
        
        // Load cached detailed Pokémon info
        let detailsURL = cacheDirectory.appendingPathComponent("pokemonDetails.json")
        if let data = try? Data(contentsOf: detailsURL),
           let cachedDetails = try? JSONDecoder().decode([Int: DetailedPokemon].self, from: data) {
            self.pokemonDetailsCache = cachedDetails
        }
    }
    
    // Cache Pokémon IDs, images, and details
    private func cacheData() {
        // Cache Pokémon IDs
        let idsURL = cacheDirectory.appendingPathComponent("pokemonIDs.json")
        if let data = try? JSONEncoder().encode(pokemonIDs) {
            try? data.write(to: idsURL)
        }
        
        // Cache image data
        let imageCacheURL = cacheDirectory.appendingPathComponent("imageCache")
        try? FileManager.default.createDirectory(at: imageCacheURL, withIntermediateDirectories: true)
        for (name, imageData) in imageCache {
            let imageURL = imageCacheURL.appendingPathComponent("\(name).png")
            try? imageData.write(to: imageURL)
        }
        
        // Cache Pokémon details
        let detailsURL = cacheDirectory.appendingPathComponent("pokemonDetails.json")
        if let data = try? JSONEncoder().encode(pokemonDetailsCache) {
            try? data.write(to: detailsURL)
        }
    }
    
    // Fetch Pokémon by type
    func getPokemonByType(pokemonType: PokemonType) {
        pokemonManager.getPokemonByType(pokemonType: pokemonType) { data in
            DispatchQueue.main.async {
                self.pokemonList = data
                
                // First, populate pokemonIDs with the correct ID for each Pokémon
                var count = 0
                for pokemon in data {
                    self.fetchAndCacheDetails(for: pokemon) {
                        count += 1
                        // Once all details have been fetched and pokemonIDs populated
                        if count == data.count {
                            // No need to fetch images for all Pokémon now, we handle it individually in the PokemonView
                        }
                    }
                }
            }
        }
    }
    
    // Fetch and cache Pokémon image by name and ID
    func fetchAndCacheImage(for name: String, id: Int) async {
        let imageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        guard let url = URL(string: imageUrlString) else { return }
        
        do {
            let data = try await URLSession.shared.data(from: url).0
            DispatchQueue.main.async {
                self.imageCache[name] = data
                self.cacheData()  // Update cache with the new image
            }
        } catch {
            print("Error fetching image for \(name): \(error)")
        }
    }
    
    // Fetch and cache Pokémon details by name
    func fetchAndCacheDetails(for pokemon: Pokemon, completion: @escaping () -> Void) {
        // Check if the Pokémon ID exists in the cache
        if let id = pokemonIDs[pokemon.name], let _ = pokemonDetailsCache[id] {
            // If both the ID and cached details are found, skip fetching
            completion()
            return
        }
        
        pokemonManager.getDetailedPokemon(name: pokemon.name) { details in
            DispatchQueue.main.async {
                // Update pokemonIDs with the fetched ID for the Pokémon
                self.pokemonIDs[pokemon.name] = details.id
                
                // Cache the details
                if let id = self.pokemonIDs[pokemon.name] {
                    self.pokemonDetailsCache[id] = details // Store details if ID is available
                    self.cacheData()  // Cache details after fetching
                }
                completion() // Signal that fetching details is done
            }
            
        }
    }
}
