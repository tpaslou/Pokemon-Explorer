import SwiftUI

struct PokemonListView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var selectedPokemon: Pokemon?
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 150))]
    @State private var itemsToShow = 10

    var body: some View {
        VStack {
            SearchBarView(searchText: $vm.searchText)

            if vm.filteredPokemon.isEmpty {
                Text("No pokemons were found")
                    .foregroundColor(.red)
                    .font(.headline)
            } else {
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        ForEach(vm.filteredPokemon.prefix(itemsToShow)) { pokemon in
                            Button(action: {
                                selectedPokemon = pokemon
                            }) {
                                PokemonView(pokemon: pokemon) // This will trigger the cache and refresh image
                            }
                        }
                    }

                    if itemsToShow < vm.filteredPokemon.count {
                        Button("Show More") {
                            itemsToShow += 10
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .navigationTitle("Pokemons found")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .background(
            NavigationLink(
                destination: selectedPokemon.map { PokemonDetailView(pokemon: $0) },
                isActive: Binding(
                    get: { selectedPokemon != nil },
                    set: { if !$0 { selectedPokemon = nil } }
                )
            ) {
                EmptyView()
            }
        )
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        TextField("Search for a Pokémon", text: $searchText)
            .padding(20)
            .padding(.horizontal, 20)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    
                    Spacer()
                }
            )
            .padding(.horizontal)
    }
}

#Preview {
    PokemonListView()
        .environmentObject(ViewModel())
}
