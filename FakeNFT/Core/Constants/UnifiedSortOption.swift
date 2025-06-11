//
//  Untitled.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import Foundation

enum UnifiedSortOption {
    // For NFTs
    case nftName(ascending: Bool)
    case nftPrice(ascending: Bool)
    case nftRating(ascending: Bool)
    
    // For Users
    case userName
    case userRating
    case userNftCount
    
    // For Collections
    case collectionName(ascending: Bool)
    case collectionNftCount(ascending: Bool)
}

extension UnifiedSortOption {
    var description: String {
        switch self {
        case .nftName(let ascending):
            return "nftName_\(ascending)"
        case .nftPrice(let ascending):
            return "nftPrice_\(ascending)"
        case .nftRating(let ascending):
            return "nftRating_\(ascending)"
        case .userName:
            return "userName"
        case .userRating:
            return "userRating"
        case .userNftCount:
            return "userNftCount"
        case .collectionName(let ascending):
            return "collectionName_\(ascending)"
        case .collectionNftCount(let ascending):
            return "collectionNftCount_\(ascending)"
        }
    }
    
    static func from(string: String) -> UnifiedSortOption? {
        let components = string.split(separator: "_")
        
        switch components.first {
        case "nftName":
            let ascending = components.count > 1 ? Bool(String(components[1])) ?? true : true
            return .nftName(ascending: ascending)
        case "nftPrice":
            let ascending = components.count > 1 ? Bool(String(components[1])) ?? true : true
            return .nftPrice(ascending: ascending)
        case "nftRating":
            let ascending = components.count > 1 ? Bool(String(components[1])) ?? true : true
            return .nftRating(ascending: ascending)
        case "userName":
            return .userName
        case "userRating":
            return .userRating
        case "userNftCount":
            return .userNftCount
        case "collectionName":
            let ascending = components.count > 1 ? Bool(String(components[1])) ?? true : true
            return .collectionName(ascending: ascending)
        case "collectionNftCount":
            let ascending = components.count > 1 ? Bool(String(components[1])) ?? true : true
            return .collectionNftCount(ascending: ascending)
        default:
            return nil
        }
    }
}
