//
//  UserService.swift
//  FakeNFT
//
//  Created by Анна Браун on 06.06.2025.
//
import Foundation

final class UserServiceImpl: UserServiceProtocol {
    let networkClient: NetworkClient
    
    enum UserServiceError: Error {
        case getAllUsersError
    }

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchAllUsers() async throws -> [User] {
        let request = AllUsersRequest()
        do {
            return try await networkClient.send(request, as: [User].self)
        } catch {
            throw UserServiceError.getAllUsersError
        }
    }
}
