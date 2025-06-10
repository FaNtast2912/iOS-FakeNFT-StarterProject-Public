//
//  MyFavoriteNFTViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 30.05.2025.
//

import Foundation

@MainActor
final class MyFavoriteNFTViewModel: ObservableObject {
    @Published var favoriteNfts: [Nft] = []
    @Published var loadingState: LoadingState = .loaded
    // моковая ссылка
    private let imageURL = URL(string: "https://sun9-71.userapi.com/"
                               + "impf/HXh-XOzRZNjBZN3-s3KY8-A1vvUZcCzEIVCO7A/NiLsvqlmqpI.jpg"
                               + "?size=320x256&quality=96&sign=cae1cfe812481cab04191c25a4dda9c4&type=album")
    private let service: ServicesAssembly
    private var likesNftId: [String] = []
    
    enum LoadingState {
        case loading
        case loaded
        case error
    }
    
    init(service: ServicesAssembly) {
        self.service = service
    }
    
    private func setMockNFTs(with image: URL?) {
        guard let image = image else { return }
        
        self.favoriteNfts = [
            Nft(
                id: "1",
                name: "NFT-1",
                createdAt: DateFormatter.defaultDateFormatter.string(from: Date()),
                images: [image],
                rating: 2,
                description: "",
                price: 14.4,
                author: "Cat"
            ),
            Nft(id: "2",
                name: "NFT-2",
                createdAt: DateFormatter.defaultDateFormatter.string(from: Date()),
                images: [image],
                rating: 4,
                description: "",
                price: 15.4,
                author: "Cat"
               ),
            Nft(
                id: "1",
                name: "NFT-1",
                createdAt: DateFormatter.defaultDateFormatter.string(from: Date()),
                images: [image],
                rating: 3,
                description: "",
                price: 8.4,
                author: "Cat"
            )]
    }
    
    func fetchLikesNft(_ loading: LoadingState = .loading) async {
        loadingState = .loading
        do {
            likesNftId = try await service.userLikesService.fetchLikes().likes
            for nftId in likesNftId {
                favoriteNfts.append(try await service.nftService.loadNft(id: nftId))
            }
            loadingState = .loaded
        } catch {
            loadingState = .error
            print(String(describing: error.localizedDescription))
        }
    }
    
    func updateLikesNft(id: String) async {
        if let index = favoriteNfts.firstIndex(where: {$0.id == id}) {
            favoriteNfts.remove(at: index)
        }
        
        if let index = likesNftId.firstIndex(of: id) {
            likesNftId.remove(at: index)
        }
        
        let dto = UserLikesRequestDto(likes: likesNftId)
        
        do {
            _ = try await service.userLikesService.updateLikes(dto: dto)
        } catch {
            print(String(describing: error.localizedDescription))
        }
    }
    
}
