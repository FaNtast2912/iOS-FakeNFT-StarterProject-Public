//
//  CartRequests.swift
//  FakeNFT
//
//  Created by Kaider on 07.06.2025.
//

import Foundation

// MARK: - DTOs

struct UpdateOrderDto: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String: String] {
        if nfts.isEmpty {
            return [:]
        }
        return ["nfts": nfts.joined(separator: ",")]
    }
}

// MARK: - Requests

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

struct PaymentRequest: NetworkRequest {
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.orders)/payment/\(currencyId)")
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
