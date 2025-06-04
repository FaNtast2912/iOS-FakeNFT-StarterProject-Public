//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 31.05.2025.
//
import Foundation

final class UserCollectionViewModel: ObservableObject {
    @Published var nfts: [Nft] = []

    func loadNfts(for user: User) {
        let allNfts = loadMockNfts()
        nfts = allNfts.filter { user.nfts.contains($0.id) }
    }

    private func loadMockNfts() -> [Nft] {
        return [
            Nft(
                id: "a",
                name: "nft1",
                createdAt: "2023-10-20T10:23:01.305Z[GMT]",
                images: [],
                rating: 2,
                description: "tacimates docendi efficitur tempus non quod cras pellentesque commune",
                price: 16.56,
                author: "https://goofy_napier.fakenfts.org/"
            ),
            Nft(
                id: "b",
                name: "nft2",
                createdAt: "2023-10-21T10:23:01.305Z[GMT]",
                images: [],
                rating: 4,
                description: "Nulla malesuada ligula id leo fringilla, ac ullamcorper urna sollicitudin.",
                price: 28.99,
                author: "https://george_brown.fakenfts.org/"
            ),
            Nft(
                id: "c",
                name: "nft3",
                createdAt: "2023-10-20T10:23:01.305Z[GMT]",
                images: [],
                rating: 2,
                description: "tacimates docendi efficitur tempus non quod cras pellentesque commune",
                price: 16.56,
                author: "https://goofy_napier.fakenfts.org/"
            ),
            Nft(
                id: "d",
                name: "nft4",
                createdAt: "2023-10-21T10:23:01.305Z[GMT]",
                images: [],
                rating: 4,
                description: "Nulla malesuada ligula id leo fringilla, ac ullamcorper urna sollicitudin.",
                price: 28.99,
                author: "https://george_brown.fakenfts.org/"
            )
        ]
    }
}
