//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import Foundation
import SwiftUI

/// Состояния загрузки для каталога
enum CatalogLoadingState {
    case idle
    case loading
    case loaded([Collection])
    case error(String)
}

/// ViewModel для экрана каталога коллекций
@MainActor
final class CatalogViewModel: ObservableObject {
    @Published var loadingState: CatalogLoadingState = .idle
    @Published var collections: [Collection] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    /// Загружает список коллекций
    func loadCollections() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        loadingState = .loading
        
        do {
            let request = CatalogRequest()
            let loadedCollections: [Collection] = try await networkClient.send(request, as: [Collection].self)
            
            collections = loadedCollections
            loadingState = .loaded(loadedCollections)
            isLoading = false
        } catch {
            let message = error.localizedDescription
            errorMessage = message
            loadingState = .error(message)
            isLoading = false
        }
    }
    
    /// Перезагружает коллекции
    func refresh() async {
        await loadCollections()
    }
}
