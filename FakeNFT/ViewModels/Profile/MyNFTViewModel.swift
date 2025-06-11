//
//  MyNFTViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 04.06.2025.
//

import Foundation

@MainActor
final class MyNFTViewModel: BaseViewModel<[Nft]> {
    @Published var showConfirmationDialog = false
    @Published var currentSortOption: UnifiedSortOption = .nftPrice(ascending: true) {
        didSet {
            UserDefaults.standard.set(currentSortOption.description, forKey: "nftSortOption")
            updateSortedNfts()
        }
    }
    @Published var sortedNfts: [Nft] = []
    @Published var likesNftId: [String] = []
    
    private var profileService: ProfileServiceProtocol {
        servicesAssembly.profileService
    }
    
    private var nftService: NftServiceProtocol {
        servicesAssembly.nftService
    }
    
    private var userLikesService: UserLikesServiceProtocol {
        servicesAssembly.userLikesService
    }
    
    override init(servicesAssembly: ServicesAssembly) {
        super.init(servicesAssembly: servicesAssembly)
        
        // Load saved sort option
        if let savedOption = UserDefaults.standard.string(forKey: "nftSortOption") {
            currentSortOption = UnifiedSortOption.from(string: savedOption) ?? .nftPrice(ascending: true)
        }
    }
    
    override func loadData() async {
        
        do {
            let profile = try await profileService.fetchProfile()
            let nfts = try await nftService.loadNfts(ids: profile.nfts)
            let likes = try await userLikesService.fetchLikes()
            
            likesNftId = likes.likes
            setLoaded(nfts)
            updateSortedNfts()
        } catch {
            handleError(error)
        }
    }
    
    func isLiked(id: String) -> Bool {
        return likesNftId.contains(id)
    }
    
    func toggleLike(for nftId: String) async {
        if likesNftId.contains(nftId) {
            likesNftId.removeAll { $0 == nftId }
        } else {
            likesNftId.append(nftId)
        }
        
        let dto = UserLikesRequestDto(likes: likesNftId)
        do {
            _ = try await userLikesService.updateLikes(dto: dto)
        } catch {
            print("Failed to update likes: \(error)")
        }
    }
    
    func setSortOption(_ option: UnifiedSortOption) {
        currentSortOption = option
    }
    
    private func updateSortedNfts() {
        guard let nfts = loadingState.data else { return }
        sortedNfts = UnifiedSortingManager.shared.sort(items: nfts, by: currentSortOption) as? [Nft] ?? nfts
    }
}
