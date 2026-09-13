import Foundation
import Testing
@testable import ApplaudoChallenge

struct AddCatValidationTests {

    @Test func stepZeroRejectsShortName() {
        let vm = AddCatViewModel()
        vm.name = "Al"
        vm.breed = "Siamese"
        #expect(vm.goNext() == false)
        #expect(vm.nameError != nil)
        #expect(vm.step == 0) // no avanza
    }

    @Test func stepZeroAcceptsValidBasicInfo() {
        let vm = AddCatViewModel()
        vm.name = "Mishi"
        vm.breed = "Criollo"
        #expect(vm.goNext() == true)
        #expect(vm.step == 1)
    }

    @Test func ageMustBePositiveNumber() {
        let vm = AddCatViewModel()
        vm.name = "Mishi"; vm.breed = "Criollo"
        _ = vm.goNext()
        vm.ageText = "cero"
        vm.about = "Le encanta dormir al sol."
        #expect(vm.goNext() == false)
        #expect(vm.ageError != nil)

        vm.ageText = "-2"
        #expect(vm.goNext() == false)

        vm.ageText = "3"
        #expect(vm.goNext() == true)
    }

    @Test func savePersistsAndSurvivesReload() {
        let defaults = UserDefaults(suiteName: "tests-\(UUID().uuidString)")!
        let store = MyCatStore(defaults: defaults)

        let vm = AddCatViewModel()
        vm.name = "Mishi"; vm.breed = "Criollo"
        vm.ageText = "4"; vm.about = "Cazadora profesional de moscas."
        _ = vm.goNext(); _ = vm.goNext()
        #expect(vm.save(into: store) == true)
        #expect(store.cats.count == 1)
        #expect(store.cats[0].age == 4)

        // "Reinicio": un store nuevo sobre los mismos defaults ve el gato.
        let reloaded = MyCatStore(defaults: defaults)
        #expect(reloaded.cats.count == 1)
        #expect(reloaded.cats[0].name == "Mishi")
    }
}
