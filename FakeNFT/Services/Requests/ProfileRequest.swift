//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 01.06.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.profile)")
    }
    
    var httpMethod: HttpMethod = .get
    var dto: Dto?
    
}
