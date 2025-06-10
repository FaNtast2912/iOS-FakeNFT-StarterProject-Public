//
//  Nft+Equatable.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

extension Nft: Equatable {
    static func == (lhs: Nft, rhs: Nft) -> Bool {
        return lhs.id == rhs.id
    }
}
