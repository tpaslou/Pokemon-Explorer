import Foundation

// The structure for the response containing the Pokémon list, damage relations, etc.
struct PokemonPage: Codable {
    let id: Int
    let name: String
    let pokemon: [PokemonEntry]  // This holds the Pokémon objects inside 'pokemon'
    let damageRelations: DamageRelations
    
    // Custom coding keys to match the JSON field names
    enum CodingKeys: String, CodingKey {
        case id, name, pokemon
        case damageRelations = "damage_relations"
    }
}

// The damage relation data which describes interactions with other Pokémon types
struct DamageRelations: Codable {
    let doubleDamageFrom: [PokemonTypeEntry]
    let doubleDamageTo: [PokemonTypeEntry]
    let halfDamageFrom: [PokemonTypeEntry]
    let halfDamageTo: [PokemonTypeEntry]
    
    // Custom coding keys to match the JSON field names
    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
        case halfDamageFrom = "half_damage_from"
        case halfDamageTo = "half_damage_to"
    }
}

// A struct that wraps around the 'pokemon' entry, which includes 'name' and 'url'
struct PokemonEntry: Codable {
    let pokemon: Pokemon  // Represents the actual Pokémon data inside 'pokemon' field
}

// Represents a single Pokémon (name and URL)
struct Pokemon: Codable, Identifiable, Equatable {
    let id = UUID()  // Unique identifier
    let name: String
    let url: String

    // Sample Pokémon for testing
    static var samplePokemon = Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")


    // Equatable comparison based on the unique 'id'
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
}

// Detailed Pokémon model with stats like HP, Attack, Defense, etc.
struct DetailedPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let stats: [Stat]
    
    // Computed properties for easy access to specific stats
    var hp: Int? {
        return stats.first { $0.statName == "hp" }?.baseStat
    }
    
    var attack: Int? {
        return stats.first { $0.statName == "attack" }?.baseStat
    }
    
    var defense: Int? {
        return stats.first { $0.statName == "defense" }?.baseStat
    }
}

// Stats model for individual Pokémon stats (HP, Attack, Defense, etc.)
struct Stat: Codable {
    let baseStat: Int
    let stat: StatInfo  // Use a nested structure to decode the stat dictionary
    
    // Computed property to get the stat name directly
    var statName: String {
        return stat.name
    }
    
    // Custom coding keys to match the JSON field names
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

// Represents the nested dictionary structure of 'stat' in the API response
struct StatInfo: Codable {
    let name: String
}

// Represents a Pokémon type (e.g., Fire, Water, etc.)
enum PokemonType: String, Codable, CaseIterable, Identifiable {
    case fire = "Fire"
    case water = "Water"
    case grass = "Grass"
    case electric = "Electric"
    case dragon = "Dragon"
    case psychic = "Psychic"
    case ghost = "Ghost"
    case dark = "Dark"
    case steel = "Steel"
    case fairy = "Fairy"
    
    var id: String { self.rawValue }

}

// Represents a Pokémon type entry with its 'name' and 'url'
struct PokemonTypeEntry: Codable {
    let name: String
    let url: String
}
