//
//  MyCatsListView.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import SwiftUI

/// Tab 3: shows cats registered by the user. Survives app restarts.
struct MyCatsListView: View {
    @ObservedObject var store: MyCatStore

    var body: some View {
        NavigationStack {
            Group {
                if store.cats.isEmpty {
                    EmptyStateView(
                        systemImage: "pawprint",
                        title: "No cats yet",
                        message: "Go to the Add Cat tab to register your first cat.",
                        buttonTitle: nil,
                        action: nil
                    )
                } else {
                    List {
                        ForEach(store.cats) { cat in
                            AppCard(
                                title: cat.name,
                                subtitle: "\(cat.breed) · \(cat.age) years",
                                imageSystemName: "cat.fill",
                                showChevron: false
                            )
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Cats")
        }
    }
}

#Preview {
    MyCatsListView(store: MyCatStore(defaults: .init(suiteName: "preview")!))
}
