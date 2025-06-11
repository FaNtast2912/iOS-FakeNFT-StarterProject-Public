//
//  CartViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct CartViewFactory: View {
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        CartView(viewModel: servicesAssembly.makeCartViewModel())
            .environmentObject(servicesAssembly.getCartManagerWrapper())
            .environmentObject(servicesAssembly.getLikesManagerWrapper())
    }
}
