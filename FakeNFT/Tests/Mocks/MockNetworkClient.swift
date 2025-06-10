//
//  MockNetworkClient.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import Foundation

class MockNetworkClient: NetworkClient {
    func send<T: Codable>(_ request: NetworkRequest, as type: T.Type) async throws -> T {
        // Return mock data based on type
        if type == [NFTCollections].self {
            let mockCollections = [
                NFTCollections(
                    id: "1",
                    name: "Mock Collection",
                    cover: URL(string: "https://example.com/image.jpg")!,
                    nfts: ["1", "2", "3"],
                    description: "Mock description",
                    author: "Mock Author",
                    createdAt: "2023-01-01"
                )
            ]
            return mockCollections as! T
        }
        
        if type == [Nft].self {
            let mockNfts = [
                Nft(id: "1", name: "Mock NFT", createdAt: "2023-01-01",
                    images: [URL(string: "https://example.com/nft.jpg")!],
                    rating: 4, description: "Mock NFT", price: 1.5, author: "Mock Author")
            ]
            return mockNfts as! T
        }
        
        throw NSError(domain: "MockError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock implementation"])
    }
}
