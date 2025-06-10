import Foundation

/// Менеджер для управления лайками NFT
@MainActor
final class LikesManager: ObservableObject {
    @Published private(set) var likedNFTs: Set<String> = []
    @Published private(set) var isLoading = false
    
    private let userLikesService: UserLikesServiceProtocol
    
    init(userLikesService: UserLikesServiceProtocol) {
        self.userLikesService = userLikesService
    }
    
    func isLiked(_ nftId: String) -> Bool {
        return likedNFTs.contains(nftId)
    }
    
    func toggleLike(for nftId: String) {
        if likedNFTs.contains(nftId) {
            likedNFTs.remove(nftId)
        } else {
            likedNFTs.insert(nftId)
        }
        
        Task {
            await syncLikesWithServer()
        }
    }
    
    func loadLikes() async {
        isLoading = true
        
        do {
            let userLikes = try await userLikesService.fetchLikes()
            likedNFTs = Set(userLikes.likes)
        } catch {
            print("❌ Ошибка загрузки лайков: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    private func syncLikesWithServer() async {
        do {
            let likesDto = UserLikesRequestDto(likes: Array(likedNFTs))
            _ = try await userLikesService.updateLikes(dto: likesDto)
        } catch {
            print("❌ Ошибка синхронизации лайков: \(error.localizedDescription)")
        }
    }
}
