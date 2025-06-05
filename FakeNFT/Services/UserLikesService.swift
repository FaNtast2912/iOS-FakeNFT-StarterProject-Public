//
//  UserLikesService.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 03.06.2025.
//

import Foundation

protocol UserLikesService {
    func fetchLikes() async throws -> UserLikes
    func updateLikes(dto: Dto) async throws -> UserLikes
}

final class UserLikesServiceImpl: UserLikesService {
    
    private let networkClient: NetworkClient
    
    enum UserLikesError: Error {
        case getLikesError
        case updateLikesError
    }

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchLikes() async throws -> UserLikes {
        let request = UserLikesRequest()
        do {
            return try await networkClient.send(request: request, type: UserLikes.self)
        } catch {
            throw UserLikesError.getLikesError
        }
    }
  
    func updateLikes(dto: Dto) async throws -> UserLikes {
        let request = UpdateUserLikesRequest(dto: dto)
        do {
            return try await networkClient.send(request: request, type: UserLikes.self)
        } catch {
            throw UserLikesError.updateLikesError
        }
    }
    
}
