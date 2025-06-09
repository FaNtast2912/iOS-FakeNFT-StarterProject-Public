//
//  CollectionDetailViewModel.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import Foundation
import SwiftUI

/// Состояния загрузки для деталей коллекции
enum CollectionDetailLoadingState {
    case idle
    case loading
    case loaded([Nft])
    case error(String)
}

/// ViewModel для экрана деталей коллекции
@MainActor
final class CollectionDetailViewModel: ObservableObject {
    @Published var loadingState: CollectionDetailLoadingState = .idle
    @Published var nfts: [Nft] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkClient: NetworkClient
    private let collection: NFTCollections
    
    init(collection: NFTCollections, networkClient: NetworkClient = DefaultNetworkClient()) {
        self.collection = collection
        self.networkClient = networkClient
    }
    
    /// Загружает NFT коллекции
    func loadNFTs() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        loadingState = .loading
        
        do {
            // Загружаем все NFT параллельно
            let nftRequests = collection.nfts.map { nftId in
                NFTRequest(id: nftId)
            }
            
            var loadedNFTs: [Nft] = []
            
            // Используем TaskGroup для параллельной загрузки
            try await withThrowingTaskGroup(of: Nft.self) { group in
                for request in nftRequests {
                    group.addTask {
                        try await self.networkClient.send(request, as: Nft.self)
                    }
                }
                
                for try await nft in group {
                    loadedNFTs.append(nft)
                }
            }
            
            // Сортируем NFT в том же порядке, что и в массиве collection.nfts
            let sortedNFTs = collection.nfts.compactMap { nftId in
                loadedNFTs.first { $0.id == nftId }
            }
            
            nfts = sortedNFTs
            loadingState = .loaded(sortedNFTs)
            isLoading = false
        } catch {
            let message = error.localizedDescription
            errorMessage = message
            loadingState = .error(message)
            isLoading = false
        }
    }
    
    /// Перезагружает NFT
    func refresh() async {
        await loadNFTs()
    }
    
    /// Возвращает коллекцию
    var currentCollection: NFTCollections {
        return collection
    }
}
