//
//  CatalogServiceImpl.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

final class CatalogServiceImpl: CatalogServiceProtocol {
    let networkClient: NetworkClient
    
    enum CatalogServiceError: Error {
        case fetchCollectionsError
    }

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCollections() async throws -> [NFTCollections] {
        let request = CatalogRequest()
        do {
            return try await networkClient.send(request, as: [NFTCollections].self)
        } catch {
            throw CatalogServiceError.fetchCollectionsError
        }
    }
}
