import Foundation

class PokemonManager {
    
    
    func getPokemonByType(pokemonType: PokemonType, completion: @escaping ([Pokemon]) -> Void) {
            let urlString = "https://pokeapi.co/api/v2/type/\(pokemonType.rawValue.lowercased())"
            
            Bundle.main.fetchData(url: urlString, model: PokemonPage.self) { data in
                let pokemonList = data.pokemon.map { $0.pokemon }
                completion(pokemonList)
            } failure: { error in
                print("Error fetching Pokémon by type: \(error)")
            }
        }
        
        func getDetailedPokemon(name: String, completion: @escaping (DetailedPokemon) -> Void) {
            let urlString = "https://pokeapi.co/api/v2/pokemon/\(name.lowercased())/"
            
            Bundle.main.fetchData(url: urlString, model: DetailedPokemon.self) { data in
                completion(data)
            } failure: { error in
                print("Error fetching detailed data: \(error)")
            }
        }
}
