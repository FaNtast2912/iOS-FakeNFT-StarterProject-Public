//
//  NFTRatingView.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import SwiftUI

/// Компонент для отображения рейтинга NFT в виде звездочек
struct NFTRatingView: View {
    let rating: Int
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: "star.fill")
                    .foregroundColor(star <= rating ? .ypYellowUniversal : .ypLightGrey)
                    .font(.system(size: 12))
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 10) {
        NFTRatingView(rating: 0)
        NFTRatingView(rating: 1)
        NFTRatingView(rating: 3)
        NFTRatingView(rating: 5)
    }
    .padding()
}
