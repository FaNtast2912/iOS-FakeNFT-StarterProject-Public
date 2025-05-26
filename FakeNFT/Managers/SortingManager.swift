//
//  SortingManager.swift
//  FakeNFT
//
//  Created by Kaider on 26.05.2025.
//

import Foundation

enum ProductSortOption {
    case name(ascending: Bool)
    case price(ascending: Bool)
    case rating(ascending: Bool)
}

final class SortingManager {
    static let shared = SortingManager()

    private init() {}

    func sort(products: [Product], by option: ProductSortOption) -> [Product] {
        switch option {
        case .name(let ascending):
            return products.sorted {
                ascending ?
                    ($0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending) :
                    ($0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending)
            }

        case .price(let ascending):
            return products.sorted {
                ascending ? $0.price < $1.price : $0.price > $1.price
            }

        case .rating(let ascending):
            return products.sorted {
                ascending ? $0.rating < $1.rating : $0.rating > $1.rating
            }
        }
    }
}
