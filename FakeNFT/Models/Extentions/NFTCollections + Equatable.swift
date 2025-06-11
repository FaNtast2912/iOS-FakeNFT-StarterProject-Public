//
//  NFTCollections + Equatable.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

extension NFTCollections: Equatable {
    static func == (lhs: NFTCollections, rhs: NFTCollections) -> Bool {
        return lhs.id == rhs.id
    }
}
