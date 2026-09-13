//
//  MyCatStore.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import Foundation

/// Saves user's cats in UserDefaults (JSON).
/// Nothing fancy: few records and no migrations to worry about.
final class MyCatStore: ObservableObject {
    @Published private(set) var cats: [MyCat] = []

    private let defaults: UserDefaults
    private let key = "myCats.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func add(_ cat: MyCat) {
        cats.append(cat)
        persist()
    }

    func remove(_ cat: MyCat) {
        cats.removeAll { $0.id == cat.id }
        persist()
    }

    // MARK: - Private

    private func load() {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([MyCat].self, from: data)
        else { return }
        cats = decoded
    }

    private func persist() {
        // Si falla el encode, se pierde el cambio pero no se rompe nada.
        if let data = try? JSONEncoder().encode(cats) {
            defaults.set(data, forKey: key)
        }
    }
}
