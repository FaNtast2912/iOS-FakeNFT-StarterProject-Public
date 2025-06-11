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
    @Published var sortOption: UnifiedSortOption = .collectionName(ascending: true) {
        didSet {
            UserDefaults.standard.set(sortOption.description, forKey: "catalogSortOption")
            updateSortedCollections()
        }
    }
    @Published var sortedCollections: [NFTCollections] = []
    
    private var catalogService: CatalogServiceProtocol {
        servicesAssembly.catalogService
    }
    
    override init(servicesAssembly: ServicesAssembly) {
        super.init(servicesAssembly: servicesAssembly)
        
        // Load saved sort option
        if let savedOption = UserDefaults.standard.string(forKey: "catalogSortOption") {
            sortOption = UnifiedSortOption.from(string: savedOption) ?? .collectionName(ascending: true)
        }
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
    }
    
    private func updateSortedCollections() {
        guard let collections = loadingState.data else { return }
        sortedCollections = UnifiedSortingManager.shared.sort(items: collections, by: sortOption) as? [NFTCollections] ?? collections
    }
}
