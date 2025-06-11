//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 31.05.2025.
//
import Foundation

@MainActor
final class UserCollectionViewModel: BaseViewModel<[Nft]> {
    private var nftService: NftServiceProtocol {
        servicesAssembly.nftService
    }
    
    override func loadData() async {
        // Should not be called without user
        fatalError("Use loadNfts(for:) instead")
    }
    
    func loadNfts(for user: User) async {
        setLoading()
        
        do {
            let nfts = try await nftService.loadNfts(ids: user.nfts)
            setLoaded(nfts)
        } catch {
            handleError(error)
        }
    }
}
