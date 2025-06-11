import SwiftUI

/// Менеджер для управления лайками NFT
actor LikesManager {
    private var likedNFTs: Set<String> = []
    private var isLoading = false
    private var error: Error?
    
    private let userLikesService: UserLikesServiceProtocol
    
    init(userLikesService: UserLikesServiceProtocol) {
        self.userLikesService = userLikesService
    }
    
    // MARK: - State Access
    
    func getLikedNFTs() -> Set<String> {
        return likedNFTs
    }
    
    func getLikedNFTsArray() -> [String] {
        return Array(likedNFTs)
    }
    
    func getLikesCount() -> Int {
        return likedNFTs.count
    }
    
    func isLiked(_ nftId: String) -> Bool {
        return likedNFTs.contains(nftId)
    }
    
    func isLiked(_ nft: Nft) -> Bool {
        return likedNFTs.contains(nft.id)
    }
    
    func getLoadingState() -> Bool {
        return isLoading
    }
    
    func getError() -> Error? {
        return error
    }
    
    // MARK: - Operations
    
    func loadLikes() async throws {
        isLoading = true
        error = nil
        
        do {
            let userLikes = try await userLikesService.fetchLikes()
            likedNFTs = Set(userLikes.likes)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            throw error
        }
    }
    
    func toggleLike(for nft: Nft) async throws {
        try await toggleLike(for: nft.id)
    }
    
    func toggleLike(for nftId: String) async throws {
        if likedNFTs.contains(nftId) {
            likedNFTs.remove(nftId)
        } else {
            likedNFTs.insert(nftId)
        }
        
        try await syncWithServer()
    }
    
    func addLike(for nft: Nft) async throws {
        try await addLike(for: nft.id)
    }
    
    func addLike(for nftId: String) async throws {
        likedNFTs.insert(nftId)
        try await syncWithServer()
    }
    
    func removeLike(for nft: Nft) async throws {
        try await removeLike(for: nft.id)
    }
    
    func removeLike(for nftId: String) async throws {
        likedNFTs.remove(nftId)
        try await syncWithServer()
    }
    
    func likeMultiple(_ nftIds: [String]) async throws {
        for nftId in nftIds {
            likedNFTs.insert(nftId)
        }
        try await syncWithServer()
    }
    
    func unlikeMultiple(_ nftIds: [String]) async throws {
        for nftId in nftIds {
            likedNFTs.remove(nftId)
        }
        try await syncWithServer()
    }
    
    func likeMultiple(_ nfts: [Nft]) async throws {
        try await likeMultiple(nfts.map { $0.id })
    }
    
    func unlikeMultiple(_ nfts: [Nft]) async throws {
        try await unlikeMultiple(nfts.map { $0.id })
    }
    
    // MARK: - Utility
    
    func canToggleLike(for nftId: String) -> Bool {
        return !isLoading
    }
    
    func getLikesCount(for author: String, from nfts: [Nft]) -> Int {
        let authorNftIds = Set(nfts.filter { $0.author == author }.map { $0.id })
        return likedNFTs.intersection(authorNftIds).count
    }
    
    func recoverFromError() async {
        if error != nil {
            do {
                try await loadLikes()
            } catch {
                // Error уже установлен в loadLikes
            }
        }
    }
    
    // MARK: - Private
    
    private func syncWithServer() async throws {
        do {
            let likesDto = UserLikesRequestDto(likes: Array(likedNFTs))
            _ = try await userLikesService.updateLikes(dto: likesDto)
            error = nil
        } catch {
            self.error = error
            throw error
        }
    }
    
    #if DEBUG
    func printDebugInfo() {
        print("❤️ Likes Debug Info:")
        print("   Likes count: \(likedNFTs.count)")
        print("   Is loading: \(isLoading)")
        print("   Liked IDs: \(Array(likedNFTs))")
        if let error = error {
            print("   Error: \(error.localizedDescription)")
        }
    }
    #endif
}
