//
//  MyFavoriteNFTViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 30.05.2025.
//

import Foundation

@MainActor
final class MyFavoriteNFTViewModel: BaseViewModel<[Nft]> {
    
    private var nftService: NftServiceProtocol {
        servicesAssembly.nftService
    }
    
    override func loadData() async {
        setLoading()
        
        do {
            // Получаем лайкнутые ID из LikesManager через ServicesAssembly
            let likedIds = await servicesAssembly.likesManager.getLikedNFTsArray()
            
            if likedIds.isEmpty {
                setLoaded([])
                return
            }
            
            let nfts = try await nftService.loadNfts(ids: likedIds)
            setLoaded(nfts)
        } catch {
            handleError(error)
        }
    }
    
    /// Проверить есть ли избранные NFT
    var hasFavorites: Bool {
        guard let nfts = loadingState.data else { return false }
        return !nfts.isEmpty
    }
    
    /// Получить количество избранных NFT
    var favoritesCount: Int {
        return loadingState.data?.count ?? 0
    }
}
