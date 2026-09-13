//
//  BreedsListView.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import SwiftUI

/// Tab 1: paginated catalog. Delegates state to the ViewModel and just draws.
struct BreedsListView: View {
    @StateObject private var vm = BreedsListViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Cats")
        }
        .onAppear { vm.loadFirst() }
    }

    // MARK: - States

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            ProgressView("Loading cats…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .empty:
            EmptyStateView(
                systemImage: "cat",
                title: "No breeds found",
                message: "Nothing came back from the API. Try again in a bit.",
                buttonTitle: "Retry",
                action: { vm.retry() }
            )
        case .failed(let msg):
            EmptyStateView(
                systemImage: "wifi.exclamationmark",
                title: "Couldn't load cats",
                message: msg,
                buttonTitle: "Try again",
                action: { vm.retry() }
            )
        case .loaded:
            breedList
        }
    }

    private var breedList: some View {
        List {
            ForEach(vm.breeds) { breed in
                NavigationLink {
                    BreedDetailView(breed: breed)
                } label: {
                    BreedRow(breed: breed)
                }
                .onAppear { vm.loadMoreIfNeeded(current: breed) }
            }

            if vm.isLoadingPage {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }

            if let err = vm.pageError {
                Button("Couldn't load more (\(err)). Tap to retry.") {
                    if let last = vm.breeds.last { vm.loadMoreIfNeeded(current: last) }
                }
                .font(AppTheme.Fonts.caption)
                .foregroundColor(AppTheme.Colors.error)
            }
        }
        .listStyle(.plain)
        .refreshable { vm.retry() }
    }
}

#Preview {
    BreedsListView()
}
