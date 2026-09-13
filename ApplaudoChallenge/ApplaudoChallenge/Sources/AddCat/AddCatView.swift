//
//  AddCatView.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import SwiftUI

/// Tab 2: stepper to register a cat. Shows confirmation on save.
struct AddCatView: View {
    @StateObject private var vm = AddCatViewModel()
    @ObservedObject var store: MyCatStore

    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.md) {
                StepperIndicator(
                    currentStep: vm.step,
                    totalSteps: vm.totalSteps,
                    stepTitles: vm.stepTitles
                )
                .padding(.top, AppTheme.Spacing.sm)

                ScrollView {
                    stepContent
                        .padding(.horizontal, AppTheme.Spacing.md)
                }

                Spacer()

                navButtons
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.bottom, AppTheme.Spacing.sm)
            }
            .navigationTitle("Add Cat")
            .alert("Cat saved", isPresented: savedBinding) {
                Button("Add another") { vm.reset() }
                Button("Done", role: .cancel) { vm.reset() }
            } message: {
                Text("\(vm.name) is now part of your collection.")
            }
        }
    }

    // MARK: - Steps

    private var savedBinding: Binding<Bool> {
        Binding(get: { vm.justSaved }, set: { if !$0 { vm.dismissSaved() } })
    }

    @ViewBuilder
    private var stepContent: some View {
        switch vm.step {
        case 0: BasicInfoStep(vm: vm)
        case 1: DetailsStep(vm: vm)
        default: ReviewStep(vm: vm)
        }
    }

    // MARK: - Buttons

    private var navButtons: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            if vm.step > 0 {
                AppButton(title: "Back", style: .secondary) { vm.goBack() }
            }

            if vm.isLastStep {
                AppButton(title: "Save cat") { _ = vm.save(into: store) }
            } else {
                AppButton(title: "Next") { _ = vm.goNext() }
            }
        }
    }
}

#Preview {
    AddCatView(store: MyCatStore(defaults: .init(suiteName: "preview")!))
}
