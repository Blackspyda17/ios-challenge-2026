//
//  Breed+Preview.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import Foundation
import NetworkLayer

/// Hand-crafted data for previews and design, not used in production.
extension Breed {
    static let previewPersian = Breed(
        id: "pers",
        name: "Persian",
        description: "Calm and affectionate, loves quiet laps and slow afternoons.",
        temperament: "Calm, Affectionate, Quiet",
        origin: "Iran",
        lifeSpan: "12 - 17",
        referenceImageId: nil,
        image: nil
    )

    static let previewNoPhoto = Breed(
        id: "mishi",
        name: "Mishi",
        description: nil,
        temperament: "Playful",
        origin: "El Salvador",
        lifeSpan: "13 - 15",
        referenceImageId: nil,
        image: nil
    )
}
