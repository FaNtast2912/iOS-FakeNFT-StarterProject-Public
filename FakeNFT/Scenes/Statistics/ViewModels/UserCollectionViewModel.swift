//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 31.05.2025.
//
import Foundation

@MainActor
final class UserCollectionViewModel: ObservableObject {
    @Published var nfts: [Nft] = []
    @Published var isLoading = false

    private let nftService: NftService

    init(nftService: NftService) {
        self.nftService = nftService
    }

    func loadNfts(for user: User) async {
        isLoading = true
        defer { isLoading = false }

        var loadedNfts: [Nft] = []

        for id in user.nfts {
            do {
                let nft = try await loadNftAsync(id: id)
                loadedNfts.append(nft)
            } catch {
                print("Ошибка загрузки NFT с id=\(id): \(error)")
            }
        }

        nfts = loadedNfts
    }

    private func loadNftAsync(id: String) async throws -> Nft {
        try await withCheckedThrowingContinuation { continuation in
            nftService.loadNft(id: id) { result in
                continuation.resume(with: result)
            }
        }
    }
}
