//
//  NftServiceImpl.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import Foundation

final class NftServiceImpl: NftServiceProtocol {
    let networkClient: NetworkClient
    private let storage: NftStorage
    
    enum NftServiceError: Error {
        case getNftError
        case invalidData
    }

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    func loadNft(id: String) async throws -> Nft {
        let request = NFTRequest(id: id)
        do {
            return try await networkClient.send(request, as: Nft.self)
        } catch {
            throw NftServiceError.getNftError
        }
    }
    
    func loadNfts(ids: [String]) async throws -> [Nft] {
        return try await withThrowingTaskGroup(of: Nft.self) { group in
            for id in ids {
                group.addTask {
                    try await self.loadNft(id: id)
                }
            }
            
            var nfts: [Nft] = []
            for try await nft in group {
                nfts.append(nft)
            }
            
            return ids.compactMap { id in
                nfts.first { $0.id == id }
            }
        }
    }
}
