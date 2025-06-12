//
//  CollectionDetailViewModel.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import SwiftUI

/// ViewModel для экрана деталей коллекции
@MainActor
final class CollectionDetailViewModel: BaseViewModel<[Nft]> {
    private let collection: NFTCollections
    
    private var nftService: NftServiceProtocol {
        servicesAssembly.nftService
    }
    
    init(collection: NFTCollections, servicesAssembly: ServicesAssembly) {
        self.collection = collection
        super.init(servicesAssembly: servicesAssembly)
    }
    
    override func loadData() async {
        setLoading()
        
        do {
            let nfts = try await nftService.loadNfts(ids: collection.nfts)
            setLoaded(nfts)
        } catch {
            handleError(error)
        }
    }
    
    /// Возвращает коллекцию
    var currentCollection: NFTCollections {
        return collection
    }
    
    /// Перезагружает NFT (алиас для совместимости)
    func loadNFTs() async {
        await loadData()
    }
    
    /// Получить загруженные NFTs (алиас для совместимости)
    var nfts: [Nft] {
        return loadingState.data ?? []
    }
    
    /// Состояние загрузки (алиас для совместимости)
    var isLoading: Bool {
        return loadingState.isLoading
    }
    
    /// Сообщение об ошибке (алиас для совместимости)
    var errorMessage: String? {
        return loadingState.error?.localizedDescription
    }
}
