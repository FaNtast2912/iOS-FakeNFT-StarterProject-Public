//
//  UpdateProfileRequest.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 03.06.2025.


import Foundation

struct UpdateProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.profile)")
    }
    
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}
