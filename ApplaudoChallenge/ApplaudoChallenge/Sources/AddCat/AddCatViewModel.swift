//
//  AddCatViewModel.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import Foundation

/// 3-step form: 0 basic info, 1 details, 2 review.
/// Each step validates before allowing to proceed (S5).
final class AddCatViewModel: ObservableObject {
    // MARK: - Step
    @Published var step = 0
    let totalSteps = 3
    let stepTitles = ["Basic", "Details", "Review"]

    // MARK: - Fields
    @Published var name = ""
    @Published var breed = ""
    @Published var ageText = ""
    @Published var about = ""

    // MARK: - Errors (nil = válido)
    @Published private(set) var nameError: String?
    @Published private(set) var breedError: String?
    @Published private(set) var ageError: String?
    @Published private(set) var aboutError: String?

    @Published private(set) var justSaved = false

    var isLastStep: Bool { step == totalSteps - 1 }

    var parsedAge: Int? {
        guard let n = Int(ageText.trimmingCharacters(in: .whitespaces)) else { return nil }
        return (1...30).contains(n) ? n : nil
    }

    // MARK: - Navigation

    @discardableResult
    func goNext() -> Bool {
        guard validateCurrent() else { return false }
        if step < totalSteps - 1 { step += 1 }
        return true
    }

    func goBack() {
        justSaved = false
        if step > 0 { step -= 1 }
    }

    func dismissSaved() {
        justSaved = false
    }

    // MARK: - Validation

    /// Valida solo el paso actual y publica los errores inline.
    @discardableResult
    func validateCurrent() -> Bool {
        switch step {
        case 0:
            nameError = name.trimmingCharacters(in: .whitespaces).count >= 3
                ? nil : "Name needs at least 3 characters"
            breedError = breed.trimmingCharacters(in: .whitespaces).isEmpty
                ? "Pick or type a breed" : nil
            return nameError == nil && breedError == nil
        case 1:
            ageError = parsedAge == nil ? "Enter an age between 1 and 30" : nil
            aboutError = about.trimmingCharacters(in: .whitespaces).count >= 10
                ? nil : "Tell us a bit more (10+ characters)"
            return ageError == nil && aboutError == nil
        default:
            return validateAll()
        }
    }

    private func validateAll() -> Bool {
        let keep = step
        step = 0; let a = validateCurrent()
        step = 1; let b = validateCurrent()
        step = keep
        return a && b
    }

    // MARK: - Save

    @discardableResult
    func save(into store: MyCatStore) -> Bool {
        guard validateAll(), let age = parsedAge else { return false }
        store.add(MyCat(name: name, breed: breed, age: age, about: about))
        justSaved = true
        return true
    }

    func reset() {
        step = 0
        name = ""; breed = ""; ageText = ""; about = ""
        nameError = nil; breedError = nil; ageError = nil; aboutError = nil
        justSaved = false
    }
}
