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
        }
        .tint(AppTheme.Colors.primary)
    }
}

#Preview {
    ContentView(store: MyCatStore(defaults: .init(suiteName: "preview")!))
}
