//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import SwiftUI

/// ViewModel для экрана каталога коллекций
@MainActor
final class CatalogViewModel: BaseViewModel<[NFTCollections]> {
    @Published var sortOption: UnifiedSortOption?
    @Published var sortedCollections: [NFTCollections] = []
    
    private var catalogService: CatalogServiceProtocol {
        servicesAssembly.catalogService
    }
    
    override func loadData() async {
        setLoading()
        
        do {
            let collections = try await catalogService.fetchCollections()
            setLoaded(collections)
            updateSortedCollections()
        } catch {
            handleError(error)
        }
    }
    
    func sortCollections(by option: UnifiedSortOption) {
        sortOption = option
        updateSortedCollections()
    }
    
    private func updateSortedCollections() {
        guard let collections = loadingState.data else { return }
        
        if let sortOption = sortOption {
            sortedCollections = UnifiedSortingManager.shared.sort(items: collections, by: sortOption) as? [NFTCollections] ?? collections
        } else {
            sortedCollections = collections
        }
    }
}
