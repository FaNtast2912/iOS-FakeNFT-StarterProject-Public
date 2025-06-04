//
//  MyNFTViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 04.06.2025.
//

import Foundation

class MyNFTViewModel: ObservableObject {
    @Published var nfts: [Nft] = []
    @Published var loadingState: LoadingState = .loaded
    @Published var showConfirmationDialog = false
    private var likesNftId: [String] = []
    private let imageURL = URL(string: "https://sun9-71.userapi.com/"
                               + "impf/HXh-XOzRZNjBZN3-s3KY8-A1vvUZcCzEIVCO7A/NiLsvqlmqpI.jpg"
                               + "?size=320x256&quality=96&sign=cae1cfe812481cab04191c25a4dda9c4&type=album")
    enum LoadingState {
        case loading
        case loaded
        case error
    }
    
    init() {
        setMockNFTs(with: imageURL)
    }
    
    private func setMockNFTs(with image: URL?) {
        guard let image = image else { return }
        
        self.nfts = [
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
    
    func isLiked(id: String) -> Bool {
        return likesNftId.contains(id)
    }
    
    func setNftLike(id: String) {
        if likesNftId.contains(id) {
            likesNftId.removeAll { $0 == id }
        } else {
            likesNftId.append(id)
        }
    }
    
    func sortNftBy(sortKey: ProductSortOption) {
        
    }
}
