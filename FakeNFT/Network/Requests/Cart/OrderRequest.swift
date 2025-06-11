//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.orders)")
    }
    
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
    
    var headers: [String: String]? {
        [
            "X-Practicum-Mobile-Token": RequestConstants.token,
            "Accept": "application/json"
        ]
    }
}
