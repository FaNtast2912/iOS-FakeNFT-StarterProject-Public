//
//  UserLikesServiceImpl.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import Foundation

final class UserLikesServiceImpl: UserLikesServiceProtocol {
    let networkClient: NetworkClient
    
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
            return try await networkClient.send(request, as: UserLikes.self)
        } catch {
            throw UserLikesError.getLikesError
        }
    }
  
    func updateLikes(dto: Dto) async throws -> UserLikes {
        let request = UpdateUserLikesRequest()
        var requestWithDto = request
        requestWithDto.dto = dto
        do {
            return try await networkClient.send(requestWithDto, as: UserLikes.self)
        } catch {
            throw UserLikesError.updateLikesError
        }
    }
}
