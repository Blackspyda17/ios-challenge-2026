//
//  BreedRow.swift
//  ApplaudoChallenge
//
//  Created by Andres on 12/9/26.
//

import SwiftUI
import NetworkLayer

/// Catalog row: photo if available, name and one line of description.
struct BreedRow: View {
    let breed: Breed

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            BreedThumb(url: breed.imageURL)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(breed.name)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Text(breed.shortDescription)
                    .font(AppTheme.Fonts.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding(.vertical, AppTheme.Spacing.sm)
    }
}

// MARK: - Thumb

private struct BreedThumb: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let img):
                img.resizable().scaledToFill()
            case .failure, .empty:
                Image(systemName: "cat")
                    .foregroundColor(AppTheme.Colors.primary)
                    .background(AppTheme.Colors.primary.opacity(0.1))
            @unknown default:
                ProgressView()
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small))
    }
}

#Preview {
    List {
        BreedRow(breed: .previewPersian)
        BreedRow(breed: .previewNoPhoto)
    }
}
