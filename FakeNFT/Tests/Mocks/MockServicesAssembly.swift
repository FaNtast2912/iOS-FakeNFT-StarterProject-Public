//
//  MockServicesAssembly.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

class MockServicesAssembly: ServicesAssembly {
    convenience init() {
        let mockNetworkClient = MockNetworkClient()
        let mockNftStorage = MockNftStorage()
        self.init(networkClient: mockNetworkClient, nftStorage: mockNftStorage)
    }
}
