//
//  ProfileServiceImpl.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

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
            return try await networkClient.send(request, as: Profile.self)
        } catch {
            throw ProfileError.getProfileError
        }
    }
  
    func updateProfile(dto: Dto) async throws -> Profile {
        let request = UpdateProfileRequest(dto: dto)
        do {
            return try await networkClient.send(request, as: Profile.self)
        } catch {
            throw ProfileError.updateProfileError
        }
    }
    
}
