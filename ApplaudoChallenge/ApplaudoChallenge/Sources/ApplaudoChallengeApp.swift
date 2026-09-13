import SwiftUI

@main
struct ApplaudoChallengeApp: App {
    @StateObject private var store = MyCatStore()

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
