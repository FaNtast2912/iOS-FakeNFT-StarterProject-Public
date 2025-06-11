//
//  Collection.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//
import Foundation

/// Модель коллекции NFT
struct NFTCollection: Codable, Identifiable {
    let id: String
    let name: String
    let cover: URL
    let nfts: [String]
    let description: String
    let author: String
    let createdAt: String
    
    /// Количество NFT в коллекции
    var nftCount: Int { nfts.count }
}
