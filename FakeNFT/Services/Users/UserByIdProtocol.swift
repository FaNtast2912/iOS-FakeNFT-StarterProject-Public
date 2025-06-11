//
//  UserByIdProtocol.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

protocol UserByIdServiceProtocol {
    func fetchUser(by id: String) async throws -> User
}
