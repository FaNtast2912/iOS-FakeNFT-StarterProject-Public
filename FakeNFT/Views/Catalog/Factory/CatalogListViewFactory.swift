//
//  CatalogListViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct CatalogListViewFactory: View {
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        CatalogListView(viewModel: servicesAssembly.makeCatalogViewModel())
    }
}
