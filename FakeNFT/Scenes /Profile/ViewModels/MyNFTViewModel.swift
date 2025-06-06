//
//  MyNFTViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 04.06.2025.
//

import Foundation

@MainActor
class MyNFTViewModel: ObservableObject {
    @Published var nfts: [Nft] = []
    @Published var sortedNfts: [Nft] = []
    @Published var loadingState: LoadingState = .loaded
    @Published var showConfirmationDialog = false
    @Published var currentFilter: String = "" {
        didSet {
            UserDefaults.standard.set(currentFilter, forKey: UserDefaultsKey.sortKey.rawValue)
        }
    }
    @Published var likesNftId: [String] = []
    private let imageURL = URL(string: "https://sun9-71.userapi.com/"
                               + "impf/HXh-XOzRZNjBZN3-s3KY8-A1vvUZcCzEIVCO7A/NiLsvqlmqpI.jpg"
                               + "?size=320x256&quality=96&sign=cae1cfe812481cab04191c25a4dda9c4&type=album")
    private let sortingManager = SortingManager.shared
    private let service: ServicesAssembly
    
    enum LoadingState {
        case loading
        case loaded
        case error
    }
    
    enum SortKeyConstants: String {
        case name
        case rating
        case price
        case notFilter
    }
    
    enum UserDefaultsKey: String {
        case sortKey
    }
    
    init(service: ServicesAssembly) {
        self.service = service
        currentFilter = UserDefaults.standard.string(forKey: UserDefaultsKey.sortKey.rawValue) ?? "notFilter"
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
    
    func setNftLike(id: String) async {
        if likesNftId.contains(id) {
            likesNftId.removeAll { $0 == id }
        } else {
            likesNftId.append(id)
        }
        
        let dto = UserLikesRequestDto(likes: likesNftId)
        do {
            try await service.userLikesService.updateLikes(dto: dto)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setFilter(by sortKey: SortKeyConstants) {
        switch sortKey {
        case .name:
            sortedNfts = sortingManager.sort(products: nfts, by: .name(ascending: true))
            currentFilter = SortKeyConstants.name.rawValue
        case .price:
            sortedNfts = sortingManager.sort(products: nfts, by: .price(ascending: true))
            currentFilter = SortKeyConstants.price.rawValue
        case .rating:
            sortedNfts = sortingManager.sort(products: nfts, by: .rating(ascending: true))
            currentFilter = SortKeyConstants.rating.rawValue
        case .notFilter:
            sortedNfts = nfts
            currentFilter = SortKeyConstants.notFilter.rawValue
        }
    }
    
    func fetchNfts(_ loading: LoadingState = .loading) async {
        loadingState = loading
        do {
            nfts = try await service.profileService.fetchProfile().nfts.asyncMap { nftId in
                try await service.nftService.loadNft(id: nftId)
            }
            likesNftId = try await service.userLikesService.fetchLikes().likes
            let filter = SortKeyConstants(rawValue: currentFilter) ?? .notFilter
            setFilter(by: filter)
            loadingState = .loaded
        } catch {
            loadingState = .error
            print(String(describing: error.localizedDescription))
        }
    }
    
    func refresh() async {
        do {
            nfts = try await service.profileService.fetchProfile().nfts.asyncMap { nftId in
                try await service.nftService.loadNft(id: nftId)
            }
            likesNftId = try await service.userLikesService.fetchLikes().likes
            let filter = SortKeyConstants(rawValue: currentFilter) ?? .notFilter
            setFilter(by: filter)
        } catch {
            print(String(describing: error.localizedDescription))
        }
    }
}

extension Sequence {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
}
