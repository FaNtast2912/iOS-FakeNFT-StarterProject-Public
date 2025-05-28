//
//  SortingManager.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import Foundation

enum ProductSortOption {
    case name(ascending: Bool)
    case price(ascending: Bool)
    case rating(ascending: Bool)
    case nftCount(ascending: Bool)
}

final class SortingManager {
    static let shared = SortingManager()
    private init() {}

    func sort(products: [Nft], by option: ProductSortOption) -> [Nft] {
        switch option {
        case .name(let ascending):
            return products.sorted {
                let result = $0.name.localizedCaseInsensitiveCompare($1.name)
                return ascending ? (result == .orderedAscending) : (result == .orderedDescending)
            }

        case .price(let ascending):
            return products.sorted {
                ascending ? ($0.price < $1.price) : ($0.price > $1.price)
            }

        case .rating(let ascending):
            return products.sorted {
                ascending ? ($0.raiting < $1.raiting) : ($0.raiting > $1.raiting)
            }

        case .nftCount(let ascending):
            let lhsCount: (Nft) -> Int = { $0.images.count }
            return products.sorted {
                ascending ? (lhsCount($0) < lhsCount($1)) : (lhsCount($0) > lhsCount($1))
            }
        }
    }
}
