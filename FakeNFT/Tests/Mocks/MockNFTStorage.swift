//
//  MockNFTStorage.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

class MockNftStorage: NftStorage {
    private var storage: [String: Nft] = [:]
    
    func saveNft(_ nft: Nft) {
        storage[nft.id] = nft
    }
    
    func getNft(with id: String) -> Nft? {
        return storage[id]
    }
}
