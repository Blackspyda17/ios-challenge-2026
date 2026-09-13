//
//  AddCatStepViews.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import SwiftUI

/// Contenido de cada paso. Van separados para que AddCatView no crezca tanto.
struct BasicInfoStep: View {
    @ObservedObject var vm: AddCatViewModel

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Basic info", subtitle: "How do we call your cat?")

            AppTextField(
                label: "Cat name",
                placeholder: "e.g. Mishi",
                text: $vm.name,
                errorMessage: vm.nameError,
                icon: "cat"
            )

            AppTextField(
                label: "Breed",
                placeholder: "e.g. Siamese",
                text: $vm.breed,
                errorMessage: vm.breedError,
                icon: "pawprint"
            )
        }
    }
}

struct DetailsStep: View {
    @ObservedObject var vm: AddCatViewModel

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Details", subtitle: "A couple more things")

            AppTextField(
                label: "Age (years)",
                placeholder: "e.g. 3",
                text: $vm.ageText,
                errorMessage: vm.ageError,
                keyboardType: .numberPad,
                icon: "birthday.cake"
            )

            AppTextField(
                label: "About",
                placeholder: "Short description…",
                text: $vm.about,
                errorMessage: vm.aboutError,
                icon: "text.alignleft"
            )
        }
    }
}

struct ReviewStep: View {
    @ObservedObject var vm: AddCatViewModel

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Review", subtitle: "Check before saving")

            AppCard(title: vm.name, subtitle: vm.breed, imageSystemName: "cat.fill", showChevron: false)

            VStack(spacing: AppTheme.Spacing.sm) {
                ReviewLine(label: "Age", value: "\(vm.ageText) years")
                ReviewLine(label: "About", value: vm.about)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
        }
    }
}

private struct ReviewLine: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Text(label)
                .font(AppTheme.Fonts.headline)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .frame(width: 60, alignment: .leading)
            Text(value)
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.textPrimary)
            Spacer()
        }
    }
}
