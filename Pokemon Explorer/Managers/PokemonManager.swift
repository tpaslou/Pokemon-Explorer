import Foundation

class PokemonManager {
    
    
    func getDetailedPokemon(name: String, completion: @escaping (DetailedPokemon) -> ()) {
        // Construct the URL using the Pokémon name
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(name.lowercased())/"
        
        // Use the fetchData helper to get detailed Pokémon data
        Bundle.main.fetchData(url: urlString, model: DetailedPokemon.self) { data in
            completion(data)
        } failure: { error in
            print("Error fetching detailed data: \(error)")
        }
    }
    
    func getPokemonByType(pokemonType: PokemonType, completion: @escaping ([Pokemon]) -> ()) {
            // Construct the URL using the pokemonType's raw value in lowercase
            print(pokemonType.rawValue.lowercased())
            let urlString = "https://pokeapi.co/api/v2/type/\(pokemonType.rawValue.lowercased())"
            
            // Fetch data from the API using the fetchData helper
            Bundle.main.fetchData(url: urlString, model: PokemonPage.self) { data in
                // Extract the list of Pokémon from the nested structure
                let pokemonList = data.pokemon.map { $0.pokemon }
                completion(pokemonList)
            } failure: { error in
                print("Error fetching Pokémon by type: \(error)")
            }
        }
}
