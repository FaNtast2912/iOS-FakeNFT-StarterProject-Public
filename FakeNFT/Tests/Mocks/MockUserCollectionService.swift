//
//  MockUserCollectionService.swift
//  FakeNFT
//
//  Created by Анна Браун on 06.06.2025.
//
import Foundation

final class MockUserCollectionService: NftService {

    private let mockNfts: [Nft] = [
        Nft(
            id: "a",
            name: "nft1",
            createdAt: "2023-10-20T10:23:01.305Z[GMT]",
            images: [],
            rating: 2,
            description: "Mock description 1",
            price: 16.56,
            author: "https://mock_author_1.com"
        ),
        Nft(
            id: "b",
            name: "nft2",
            createdAt: "2023-10-21T10:23:01.305Z[GMT]",
            images: [],
            rating: 4,
            description: "Mock description 2",
            price: 28.99,
            author: "https://mock_author_2.com"
        ),
        Nft(
            id: "c",
            name: "nft3",
            createdAt: "2023-10-22T10:23:01.305Z[GMT]",
            images: [],
            rating: 3,
            description: "Mock description 3",
            price: 19.99,
            author: "https://mock_author_3.com"
        )
    ]
    
    func loadNft(id: String) async throws -> Nft {
        guard let nft = self.mockNfts.first(where: { $0.id == id }) else {
            return Nft(
            id: "c",
            name: "nft3",
            createdAt: "2023-10-22T10:23:01.305Z[GMT]",
            images: [],
            rating: 3,
            description: "Mock description 3",
            price: 19.99,
            author: "https://mock_author_3.com"
        ) }
        return nft
    }
}
