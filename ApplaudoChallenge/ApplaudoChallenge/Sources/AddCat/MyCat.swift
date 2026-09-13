//
//  MyCat.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import Foundation

/// Gato registrado por el usuario. Vive en UserDefaults como JSON,
/// suficiente para una lista personal que debe sobrevivir reinicios.
struct MyCat: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var breed: String
    var age: Int
    var about: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        breed: String,
        age: Int,
        about: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.breed = breed
        self.age = age
        self.about = about
        self.createdAt = createdAt
    }
}
