//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import Foundation

/// Запрос для получения списка коллекций
struct CatalogRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + RequestConstants.collections)
    }
    
    var httpMethod: HttpMethod {
        .get
    }
    
    var dto: Dto? {
        nil
    }
}
