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
    
    private var profileService: ProfileServiceProtocol {
        servicesAssembly.profileService
    }
    
    private var nftService: NftServiceProtocol {
        servicesAssembly.nftService
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
            
            setLoaded(nfts)
            updateSortedNfts()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Sorting
    
    func setSortOption(_ option: UnifiedSortOption) {
        currentSortOption = option
    }
    
    private func updateSortedNfts() {
        guard let nfts = loadingState.data else { return }
        sortedNfts = UnifiedSortingManager.shared.sort(items: nfts, by: currentSortOption) as? [Nft] ?? nfts
    }
}
