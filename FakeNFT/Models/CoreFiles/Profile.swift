//
//  Profile.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 03.06.2025.
//

import Foundation

struct Profile: Codable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
