//
//  UnifiedSortingManager.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

final class UnifiedSortingManager {
    static let shared = UnifiedSortingManager()
    private init() {}
    
    func sort<T>(items: [T], by option: UnifiedSortOption) -> [T] {
        switch option {
        case .nftName(let ascending):
            guard let nfts = items as? [Nft] else { return items }
            return nfts.sorted {
                let result = $0.name.localizedCaseInsensitiveCompare($1.name)
                return ascending ? (result == .orderedAscending) : (result == .orderedDescending)
            } as? [T] ?? items
            
        case .nftPrice(let ascending):
            guard let nfts = items as? [Nft] else { return items }
            return nfts.sorted {
                ascending ? ($0.price < $1.price) : ($0.price > $1.price)
            } as? [T] ?? items
            
        case .nftRating(let ascending):
            guard let nfts = items as? [Nft] else { return items }
            return nfts.sorted {
                ascending ? ($0.rating < $1.rating) : ($0.rating > $1.rating)
            } as? [T] ?? items
            
        case .userName:
            guard let users = items as? [User] else { return items }
            return users.sorted {
                let result = $0.name.localizedCaseInsensitiveCompare($1.name)
                return result == .orderedAscending
            } as? [T] ?? items
            
        case .userRating:
            guard let users = items as? [User] else { return items }
            return users.sorted {
                (Int($0.rating) ?? 0) > (Int($1.rating) ?? 0)
            } as? [T] ?? items
            
        case .userNftCount:
            guard let users = items as? [User] else { return items }
            return users.sorted {
                if $0.nfts.count != $1.nfts.count {
                    return $0.nfts.count > $1.nfts.count
                } else {
                    return (Int($0.rating) ?? 0) > (Int($1.rating) ?? 0)
                }
            } as? [T] ?? items
            
        case .collectionName(let ascending):
            guard let collections = items as? [NFTCollections] else { return items }
            return collections.sorted {
                let result = $0.name.localizedCaseInsensitiveCompare($1.name)
                return ascending ? (result == .orderedAscending) : (result == .orderedDescending)
            } as? [T] ?? items
            
        case .collectionNftCount(let ascending):
            guard let collections = items as? [NFTCollections] else { return items }
            return collections.sorted {
                ascending ? ($0.nftCount < $1.nftCount) : ($0.nftCount > $1.nftCount)
            } as? [T] ?? items
        }
    }
}
