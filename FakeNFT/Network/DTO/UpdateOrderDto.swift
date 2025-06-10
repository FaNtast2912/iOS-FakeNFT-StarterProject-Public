//
//  UpdateOrderDto.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import Foundation

struct UpdateOrderDto: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String: String] {
        if nfts.isEmpty {
            return [:]
        }
        return ["nfts": nfts.joined(separator: ",")]
    }
}
