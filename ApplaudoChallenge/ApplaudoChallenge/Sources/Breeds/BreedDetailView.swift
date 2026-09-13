//
//  BreedDetailView.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import SwiftUI
import NetworkLayer

/// Breed card: photo, description and key facts. Reached by tapping the list.
struct BreedDetailView: View {
    let breed: Breed

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                headerImage

                Text(breed.name)
                    .font(AppTheme.Fonts.largeTitle)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Text(breed.shortDescription)
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                SectionHeader(title: "Facts", subtitle: "What makes this breed special")

                FactRow(label: "Origin", value: breed.origin ?? "Unknown")
                FactRow(label: "Temperament", value: breed.temperament ?? "—")
                FactRow(label: "Life span", value: breed.lifeSpan.map { "\($0) years" } ?? "—")
            }
            .padding(AppTheme.Spacing.md)
        }
        .navigationTitle(breed.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var headerImage: some View {
        AsyncImage(url: breed.imageURL) { phase in
            switch phase {
            case .success(let img):
                img.resizable().scaledToFill()
            case .failure, .empty:
                ZStack {
                    AppTheme.Colors.surface
                    Image(systemName: "cat.fill")
                        .font(.largeTitle)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            @unknown default:
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
    }
}

// MARK: - Fact row

private struct FactRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(AppTheme.Fonts.headline)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}

#Preview {
    NavigationStack {
        BreedDetailView(breed: .previewPersian)
    }
}
