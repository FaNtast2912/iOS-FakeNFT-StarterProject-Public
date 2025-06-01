//
//  SortingManagerUser.swift
//  FakeNFT
//
//  Created by Анна Браун on 01.06.2025.
//
import Foundation

enum UsertSortOption {
    case name(ascending: Bool)
    case rating(ascending: Bool)
    case initial
}

final class SortingManagerUser {
    static let shared = SortingManagerUser()
    private init() {}
    
    func sort(users: [User], by option: UsertSortOption) -> [User] {
        switch option {
            
        case .name(let ascending):
            return users.sorted {
                let result = $0.name.localizedCaseInsensitiveCompare($1.name)
                return ascending ? (result == .orderedAscending) : (result == .orderedDescending)
            }
            
        case .rating(let ascending):
            return users.sorted {
                ascending ? ($0.rating < $1.rating) : ($0.rating > $1.rating)
            }
            
        case .initial:
            return users.sorted { $0.nfts.count > $1.nfts.count }
        }
    }
}
