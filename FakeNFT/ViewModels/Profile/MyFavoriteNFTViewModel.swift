//
//  MyFavoriteNFTViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 30.05.2025.
//

import Foundation

@MainActor
final class MyFavoriteNFTViewModel: BaseViewModel<[Nft]> {
    private var likesNftId: [String] = []
    
    private var userLikesService: UserLikesServiceProtocol {
        servicesAssembly.userLikesService
    }
    
    private var nftService: NftServiceProtocol {
        servicesAssembly.nftService
    }
    
    override func loadData() async {
        
        do {
            let likes = try await userLikesService.fetchLikes()
            likesNftId = likes.likes
            
            let nfts = try await nftService.loadNfts(ids: likesNftId)
            setLoaded(nfts)
        } catch {
            handleError(error)
        }
    }
    
    func removeLike(for nftId: String) async {
        // Update local state immediately
        if let index = loadingState.data?.firstIndex(where: { $0.id == nftId }) {
            var updatedNfts = loadingState.data ?? []
            updatedNfts.remove(at: index)
            setLoaded(updatedNfts)
        }
        
        if let index = likesNftId.firstIndex(of: nftId) {
            likesNftId.remove(at: index)
        }
        
        let dto = UserLikesRequestDto(likes: likesNftId)
        
        do {
            _ = try await userLikesService.updateLikes(dto: dto)
        } catch {
            print("Failed to update likes: \(error)")
            // Could revert local changes here
            await loadData()
        }
    }
}
