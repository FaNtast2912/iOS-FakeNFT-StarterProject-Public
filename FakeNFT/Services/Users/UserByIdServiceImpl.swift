//
//  UserByIdService.swift
//  FakeNFT
//
//  Created by Анна Браун on 06.06.2025.
//
import Foundation

final class UserByIdServiceImpl: UserByIdServiceProtocol {
    let networkClient: NetworkClient
    
    enum UserByIdServiceError: Error {
        case getUserByIdError
    }

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUser(by id: String) async throws -> User {
        let request = UserByIdRequest(id: id)
        do {
            return try await networkClient.send(request, as: User.self)
        } catch {
            throw UserByIdServiceError.getUserByIdError
        }
    }
}

