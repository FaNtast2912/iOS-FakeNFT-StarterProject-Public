//
//  CatalogServiceProtocol.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

protocol CatalogServiceProtocol: ServiceProtocol {
    func fetchCollections() async throws -> [NFTCollections]
}
