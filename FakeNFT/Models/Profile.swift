//
//  Profile.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 03.06.2025.
//

struct Profile: Codable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
