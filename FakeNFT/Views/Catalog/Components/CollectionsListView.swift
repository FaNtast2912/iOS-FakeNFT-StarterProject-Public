//
//  CollectionsListView.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import SwiftUI

/// Список NFT в коллекции (сетка 3 колонки)
struct CollectionsListView: View {
    let nfts: [Nft]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 9), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(nfts, id: \.id) { nft in
                NFTItemViewCatalog(nft: nft)
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    let sampleNFTs = [
        Nft(
            id: "1",
            name: "Archie",
            createdAt: "2023-06-22T07:37:31.777Z[GMT]",
            images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/1.png")!],
            rating: 4,
            description: "Sample NFT 1",
            price: 1.78,
            author: "Author 1"
        ),
        Nft(
            id: "2",
            name: "Ruby",
            createdAt: "2023-06-22T07:37:31.777Z[GMT]",
            images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/2.png")!],
            rating: 2,
            description: "Sample NFT 2",
            price: 2.05,
            author: "Author 2"
        ),
        Nft(
            id: "3",
            name: "Nacho",
            createdAt: "2023-06-22T07:37:31.777Z[GMT]",
            images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/3.png")!],
            rating: 5,
            description: "Sample NFT 3",
            price: 0.99,
            author: "Author 3"
        )
    ]
    
    ScrollView {
        CollectionsListView(nfts: sampleNFTs)
    }
}
