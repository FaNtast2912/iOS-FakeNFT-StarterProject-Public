//
//  Users.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//
import Foundation

struct User: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
}
