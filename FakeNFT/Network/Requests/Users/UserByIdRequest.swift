//
//  UserByIdRequest.swift
//  FakeNFT
//
//  Created by Анна Браун on 06.06.2025.
//

import Foundation

struct UserByIdRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.users)/\(id)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto? = nil
}

