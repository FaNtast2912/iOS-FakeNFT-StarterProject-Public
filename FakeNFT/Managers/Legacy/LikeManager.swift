import Foundation

/// Менеджер для управления лайками NFT
final class LikesManager: ObservableObject {
    @Published private(set) var likedNFTs: Set<String> = []
    @Published private(set) var isLoading = false
    
    private let userLikesService: UserLikesServiceProtocol
    
    init(userLikesService: UserLikesServiceProtocol) {
        self.userLikesService = userLikesService
    }
    
    // MARK: - Public Methods
    
    /// Проверяет, лайкнут ли NFT
    func isLiked(_ nftId: String) -> Bool {
        return likedNFTs.contains(nftId)
    }
    
    /// Переключает лайк для NFT
    @MainActor
    func toggleLike(for nftId: String) {
        // Мгновенно обновляем UI
        if likedNFTs.contains(nftId) {
            likedNFTs.remove(nftId)
        } else {
            likedNFTs.insert(nftId)
        }
        
        // Синхронизируем с сервером в фоне
        Task {
            await syncLikesWithServer()
        }
    }
    
    /// Загружает лайки с сервера
    @MainActor
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
    
    // MARK: - Private Methods
    
    /// Синхронизирует локальные лайки с сервером
    private func syncLikesWithServer() async {
        do {
            let likesDto = UserLikesRequestDto(likes: Array(likedNFTs))
            _ = try await userLikesService.updateLikes(dto: likesDto)
        } catch {
            print("❌ Ошибка синхронизации лайков: \(error.localizedDescription)")
            // В случае ошибки можно добавить retry логику или показать уведомление
        }
    }
}
