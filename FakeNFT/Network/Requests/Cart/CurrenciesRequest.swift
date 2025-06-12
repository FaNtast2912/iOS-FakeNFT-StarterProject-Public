//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.currencies)")
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

struct CurrencyRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.currencies)/\(id)")
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
