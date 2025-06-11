//
//  UpdateOrderRequest.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    let nftIds: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.orders)")
    }
    
    var httpMethod: HttpMethod { .put }
    var dto: Dto? { UpdateOrderDto(nfts: nftIds) }
    
    var headers: [String: String]? {
        [
            "X-Practicum-Mobile-Token": RequestConstants.token,
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
    }
}
