//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 03.06.2025.
//

import Foundation

protocol ProfileService {
    func fetchProfile() async throws -> Profile
    func updateProfile(dto: Dto) async throws -> Profile
}

final class ProfileServiceImpl: ProfileService {
    
    private let networkClient: NetworkClient
    
    enum ProfileError: Error {
        case getProfileError
        case updateProfileError
    }

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile() async throws -> Profile {
        let request = ProfileRequest()
        do {
            return try await networkClient.send(request: request, type: Profile.self)
        } catch {
            throw ProfileError.getProfileError
        }
    }
  
    func updateProfile(dto: Dto) async throws -> Profile {
        let request = UpdateProfileRequest(dto: dto)
        do {
            return try await networkClient.send(request: request, type: Profile.self)
        } catch {
            throw ProfileError.updateProfileError
        }
    }
    
}
