//
//  UserServiceProtocol.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

protocol UserServiceProtocol {
    func fetchAllUsers() async throws -> [User]
}
