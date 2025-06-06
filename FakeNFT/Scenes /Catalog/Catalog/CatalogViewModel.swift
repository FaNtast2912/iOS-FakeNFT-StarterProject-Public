//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import SwiftUI

/// Состояния загрузки для каталога
enum CatalogLoadingState {
    case idle
    case loading
    case loaded([NFTCollection])
    case error(String)
}

/// Опции сортировки коллекций
enum CollectionSortOption {
    case name(ascending: Bool)
    case nftCount(ascending: Bool)
}

/// ViewModel для экрана каталога коллекций
@MainActor
final class CatalogViewModel: ObservableObject {
    @Published var loadingState: CatalogLoadingState = .idle
    @Published var collections: [NFTCollection] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var sortOption: CollectionSortOption?
    
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
            let loadedCollections: [NFTCollection] = try await networkClient.send(request, as: [NFTCollection].self)
            
            collections = loadedCollections
            if let sortOption = sortOption {
                sortCollections(by: sortOption)
            }
            loadingState = .loaded(collections)
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
    
    /// Сортирует коллекции
    func sortCollections(by option: CollectionSortOption) {
        sortOption = option
        switch option {
        case .name(let ascending):
            collections.sort {
                let result = $0.name.localizedCaseInsensitiveCompare($1.name)
                return ascending ? (result == .orderedAscending) : (result == .orderedDescending)
            }
        case .nftCount(let ascending):
            collections.sort {
                ascending ? ($0.nftCount < $1.nftCount) : ($0.nftCount > $1.nftCount)
            }
        }
        loadingState = .loaded(collections)
    }
}
