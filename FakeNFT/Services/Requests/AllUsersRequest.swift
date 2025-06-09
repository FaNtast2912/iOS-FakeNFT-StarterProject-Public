//
//  AllUsersRequest.swift
//  FakeNFT
//
//  Created by Анна Браун on 06.06.2025.
//
import Foundation

struct AllUsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.users)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto? = nil
}
