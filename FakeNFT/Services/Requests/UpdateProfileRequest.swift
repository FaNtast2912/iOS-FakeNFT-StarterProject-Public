//
//  UpdateProfileRequest.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 03.06.2025.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.profile)")
    }
    
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

struct UpdateProfileDto: Dto {
    var avatar: String
    var name: String
    var description: String
    var website: String

    private enum ProfileKeys: String {
        case avatar, name, description, website
    }

    func asDictionary() -> [String: String] {
        [ProfileKeys.avatar.rawValue: avatar,
         ProfileKeys.name.rawValue: name,
         ProfileKeys.description.rawValue: description,
         ProfileKeys.website.rawValue: website]
    }
}
