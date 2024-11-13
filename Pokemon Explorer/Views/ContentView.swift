import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    @State private var selectedType: PokemonType = .fire // Set default type
    @State private var isSearching = false // State to control navigation

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome to Pokémon Explorer")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.blue)

                Text("Choose a Pokémon type:")
                    .font(.system(size: 30))
                    .foregroundColor(.secondary)

                VStack {
                    Text("Select Type")
                        .font(.headline)
                        .foregroundColor(.blue)

                    Picker("Type", selection: $selectedType) {
                        ForEach(PokemonType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                                .tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.vertical)

                Button(action: {
                    // Trigger the API call
                    vm.getPokemonByType(pokemonType: selectedType)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        isSearching = true
                    }
                }) {
                    Text("Search")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)
                .padding()
                
                // Use NavigationLink to move to PokemonListView when isSearching is true
                NavigationLink(
                    destination: PokemonListView().environmentObject(vm),
                    isActive: $isSearching
                ) {
                    EmptyView()
                }
            }
            .padding()
        }
        .environmentObject(vm)
    }
}

#Preview {
    ContentView()
}
