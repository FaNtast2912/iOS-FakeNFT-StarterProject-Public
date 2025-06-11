//
//  UserService.swift
//  FakeNFT
//
//  Created by Анна Браун on 06.06.2025.
//
import Foundation

protocol UserService {
    func fetchAllUsers() async throws -> [User]
}

final class UserServiceImpl: UserService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchAllUsers() async throws -> [User] {
        let request = AllUsersRequest()
        return try await networkClient.send(request, as: [User].self)
    }
}
