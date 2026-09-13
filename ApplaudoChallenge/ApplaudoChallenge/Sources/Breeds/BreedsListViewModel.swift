//
//  BreedsListViewModel.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import Combine
import Foundation
import NetworkLayer

// MARK: - Load State

enum BreedsLoadState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case failed(String)
}

// MARK: - ViewModel

/// Paginated catalog. The first page defines the global state;
/// subsequent ones only add (the old list never gets cleared when paginating).
@MainActor
final class BreedsListViewModel: ObservableObject {
    @Published private(set) var breeds: [Breed] = []
    @Published private(set) var state: BreedsLoadState = .idle
    @Published private(set) var isLoadingPage = false
    @Published private(set) var pageError: String?

    private let service: CatBreedServiceType
    private let pageSize = 10
    private var page = 0
    private var hasMore = true
    private var bag = Set<AnyCancellable>()

    init(service: CatBreedServiceType = CatBreedService()) {
        self.service = service
    }

    // MARK: - First load

    func loadFirst() {
        guard state == .idle else { return }
        state = .loading
        page = 0
        hasMore = true
        fetch(page: 0, isFirst: true)
    }

    func retry() {
        state = .idle
        pageError = nil
        loadFirst()
    }

    // MARK: - Pagination

    /// Called from the visible row; triggers the next page
    /// when there are 3 or fewer below.
    func loadMoreIfNeeded(current breed: Breed) {
        guard hasMore, !isLoadingPage, state == .loaded else { return }
        let threshold = max(breeds.count - 3, 0)
        guard let idx = breeds.firstIndex(of: breed), idx >= threshold else { return }
        isLoadingPage = true
        fetch(page: page + 1, isFirst: false)
    }

    // MARK: - Private

    private func fetch(page: Int, isFirst: Bool) {
        pageError = nil
        service.breeds(limit: pageSize, page: page)
            .sink { [weak self] done in
                guard let self else { return }
                if case .failure(let err) = done {
                    if isFirst {
                        self.state = .failed(err.localizedDescription)
                    } else {
                        self.isLoadingPage = false
                        self.pageError = err.localizedDescription
                    }
                }
            } receiveValue: { [weak self] batch in
                guard let self else { return }
                self.hasMore = batch.count == self.pageSize
                if isFirst {
                    self.breeds = batch
                    self.state = batch.isEmpty ? .empty : .loaded
                } else {
                    self.page = page
                    self.breeds += batch
                    self.isLoadingPage = false
                }
            }
            .store(in: &bag)
    }
}
