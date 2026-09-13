import SwiftUI

public struct ContentView: View {
    @ObservedObject var store: MyCatStore

    init(store: MyCatStore) {
        self.store = store
    }

    public var body: some View {
        TabView {
            // MARK: - Tab 1: Cat List
            BreedsListView()
                .tabItem {
                    Label("Cats", systemImage: "cat")
                }

            // MARK: - Tab 2: Add Cat
            AddCatView(store: store)
                .tabItem {
                    Label("Add Cat", systemImage: "plus.circle")
                }

            // MARK: - Tab 3: My Cats
            MyCatsListView(store: store)
                .tabItem {
                    Label("My Cats", systemImage: "pawprint.fill")
                }
        }
        .tint(AppTheme.Colors.primary)
    }
}

#Preview {
    ContentView(store: MyCatStore(defaults: .init(suiteName: "preview")!))
}
