//
//  UpdateUserLikesRequest.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import Foundation

struct UpdateUserLikesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.profile)")
    }
    
    var httpMethod: HttpMethod = .put
    var dto: Dto?
    
}
