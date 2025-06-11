//
//  SortingManagerUser.swift
//  FakeNFT
//
//  Created by Анна Браун on 01.06.2025.
//
import Foundation

enum UsertSortOption: String {
    case name
    case rating
    case initial
}

final class SortingManagerUser {
    static let shared = SortingManagerUser()
    private init() {}
    
    func sort(users: [User], by option: UsertSortOption) -> [User] {
        switch option {
            
        case .name:
            return users.sorted {
                let result = $0.name.localizedCaseInsensitiveCompare($1.name)
                return result == .orderedAscending
            }
            
        case .rating:
            return users.sorted {
                (Int($0.rating) ?? 0) > (Int($1.rating) ?? 0)
            }
            
        case .initial:
            return users.sorted {
                if $0.nfts.count != $1.nfts.count {
                    return $0.nfts.count > $1.nfts.count
                } else {
                    return (Int($0.rating) ?? 0) > (Int($1.rating) ?? 0)
                }
            }
        }
    }
}
