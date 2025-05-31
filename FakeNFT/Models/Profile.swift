//
//  Profile.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//

import Foundation

struct Profile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
