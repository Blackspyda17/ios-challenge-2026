//
//  CatBreedService.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import Combine
import Foundation
import Moya

// MARK: - Service Type

/// What screens need from the catalog. Injected into ViewModels.
public protocol CatBreedServiceType {
    func breeds(limit: Int, page: Int) -> AnyPublisher<[Breed], NetworkError>
}

// MARK: - Service

public struct CatBreedService: CatBreedServiceType {
    private let requester: NetworkingRequesterType

    public init(requester: NetworkingRequesterType) {
        self.requester = requester
    }

    /// Shortcut for production: real requester with the shared provider.
    public init() {
        self.init(requester: NetworkingRequester(provider: .networkingProvider()))
    }

    public func breeds(limit: Int, page: Int) -> AnyPublisher<[Breed], NetworkError> {
        requester.execute(
            request: CatInformationTarget.listBreeds(limit: limit, page: page)
        )
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
