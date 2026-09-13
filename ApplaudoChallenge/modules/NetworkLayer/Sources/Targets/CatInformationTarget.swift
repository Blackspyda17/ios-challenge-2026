//
//  CatInformationTarget.swift
//  ApplaudoChallenge
//
//  Created by Christian Rivera on 25/3/26.
//

import Moya

// MARK: - Cat Information Target
/// Sample target — use this as a reference when building new service targets.
///
/// Each case represents a distinct API operation. To add a new endpoint,
/// declare a new case here and handle it in every computed property below.
enum CatInformationTarget {
    /// Fetches a random cat image from the API.
    case getCatImage
    /// Paged breed catalog. The API honors limit/page as query params.
    case listBreeds(limit: Int, page: Int)
}

// MARK: - NetworkingTargetType Conformance
extension CatInformationTarget: NetworkingTargetType {
    /// The path component appended to the base URL for each endpoint.
    var requestPath: String {
        switch self {
        case .getCatImage:
            return "images/search" // Full URL: https://api.thecatapi.com/v1/images/search
        case .listBreeds:
            return "breeds"
        }
    }

    /// The HTTP method used for each endpoint.
    var requestMethod: RequestMethod {
        switch self {
        case .getCatImage:
            return .get
        case .listBreeds:
            return .get
        }
    }

    /// The Moya task that describes the request body or query parameters for each endpoint.
    var task: Moya.Task {
        switch self {
        case .getCatImage:
            return .requestPlain
        case .listBreeds(let limit, let page):
            return .requestParameters(
                parameters: ["limit": limit, "page": page],
                encoding: URLEncoding.queryString
            )
        }
    }
}
