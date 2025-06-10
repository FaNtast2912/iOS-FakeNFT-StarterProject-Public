//
//  UserLikesServiceImpl.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import Foundation

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
