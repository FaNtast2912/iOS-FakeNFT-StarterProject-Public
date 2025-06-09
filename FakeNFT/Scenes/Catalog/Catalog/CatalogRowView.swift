//
//  CatalogRowView.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import SwiftUI

/// Ячейка каталога для отображения одной коллекции NFT
struct CatalogRowView: View {
    let collection: NFTCollections
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: collection.cover) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.ypLightGrey)
                    .overlay {
                        ProgressView()
                            .tint(.ypBlueUniversal)
                    }
            }
            .frame(height: 140)
            .clipped()
            .cornerRadius(12, corners: .allCorners)
            
            VStack(alignment: .leading, spacing: 0) {
                Text( "\(collection.name) (\(collection.nftCount))")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .foregroundColor(.ypBlack)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(height: 179)
        .background(Color.ypWhite)
        .cornerRadius(12)
    }
}

// MARK: - Preview
#Preview {
    let sampleCollection = NFTCollections(
        id: "sample-id",
        name: "Peach",
        cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png")!,
        nfts: Array(repeating: "nft-id", count: 11),
        description: "Sample description",
        author: "Sample Author",
        createdAt: "2023-11-21T15:21:36.683Z[GMT]"
    )
    
    CatalogRowView(collection: sampleCollection)
        .padding()
        .previewLayout(.sizeThatFits)
}


