//
//  UserByIdService.swift
//  FakeNFT
//
//  Created by Анна Браун on 06.06.2025.
//
import Foundation

protocol UserByIdService {
    func fetchUser(by id: String) async throws -> User
}

final class UserByIdServiceImpl: UserByIdService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUser(by id: String) async throws -> User {
        let request = UserByIdRequest(id: id)
        return try await networkClient.send(request, as: User.self)
    }
}

