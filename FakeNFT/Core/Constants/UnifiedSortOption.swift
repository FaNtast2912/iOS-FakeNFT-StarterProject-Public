//
//  Untitled.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

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
