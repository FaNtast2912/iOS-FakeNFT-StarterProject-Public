//
//  CollectionDetailView.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct CollectionDetailViewFactory: View {
    let collection: NFTCollections
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        CollectionDetailView(
            viewModel: servicesAssembly.makeCollectionDetailViewModel(collection: collection)
        )
    }
}
