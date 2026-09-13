//
//  Breed.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import Foundation

// MARK: - Breed Image

/// Nest from the /breeds response when the breed has a reference image.
public struct BreedImage: Decodable, Equatable {
    public let id: String
    public let url: String?
    public let width: Int?
    public let height: Int?

    public init(id: String, url: String? = nil, width: Int? = nil, height: Int? = nil) {
        self.id = id
        self.url = url
        self.width = width
        self.height = height
    }
}

// MARK: - Breed

/// Cat breed as returned by TheCatAPI in GET /breeds.
/// We only model what the app uses; the rest of the payload is ignored.
public struct Breed: Decodable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let description: String?
    public let temperament: String?
    public let origin: String?
    public let lifeSpan: String?
    public let referenceImageId: String?
    public let image: BreedImage?

    public init(
        id: String,
        name: String,
        description: String? = nil,
        temperament: String? = nil,
        origin: String? = nil,
        lifeSpan: String? = nil,
        referenceImageId: String? = nil,
        image: BreedImage? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.temperament = temperament
        self.origin = origin
        self.lifeSpan = lifeSpan
        self.referenceImageId = referenceImageId
        self.image = image
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case temperament
        case origin
        case lifeSpan = "life_span"
        case referenceImageId = "reference_image_id"
        case image
    }

    /// Preferred URL to display: the embedded one, or the one built with reference_image_id.
    public var imageURL: URL? {
        if let url = image?.url {
            return URL(string: url)
        }
        guard let ref = referenceImageId else { return nil }
        return URL(string: "https://cdn2.thecatapi.com/images/\(ref).jpg")
    }

    public var shortDescription: String {
        description ?? "No description available."
    }
}
