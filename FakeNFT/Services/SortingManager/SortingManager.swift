//
//  SortingManager.swift
//  FakeNFT
//
//  Created by Kaider on 24.05.2025.
//

import Foundation
import CoreData

enum ProductSortType {
    case byName(ascending: Bool)
    case byPrice(ascending: Bool)
    case byRating(ascending: Bool)
}

extension NSFetchRequest where ResultType == Product {
    static func sorted(by sortType: ProductSortType) -> NSFetchRequest<Product> {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        switch sortType {
        case .byName(let ascending):
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: ascending)]
        case .byPrice(let ascending):
            request.sortDescriptors = [NSSortDescriptor(key: "price", ascending: ascending)]
        case .byRating(let ascending):
            request.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: ascending)]
        }
        return request
    }
}

extension Array where Element: Product {
    func sorted(by sortType: ProductSortType) -> [Product] {
        switch sortType {
            
        case .byName(let ascending): // Сортировка по имени
            return self.sorted {
                if ascending {
                    return ($0.name ?? "") < ($1.name ?? "")
                } else {
                    return ($0.name ?? "") > ($1.name ?? "")
                }
            }
        case .byPrice(let ascending): // Сортировка по цене
            return self.sorted {
                ascending
                ? $0.price < $1.price
                : $0.price > $1.price
            }
        case .byRating(let ascending): // Сортировка по рейтингу
            return self.sorted {
                ascending
                ? $0.rating < $1.rating
                : $0.rating > $1.rating
            }
        }
    }
}
        
