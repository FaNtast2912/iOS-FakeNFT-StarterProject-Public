//
//  MyFavoriteNFTViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct MyFavoriteNFTViewFactory: View {
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        MyFavoriteNFTView(viewModel: servicesAssembly.makeMyFavoriteNFTViewModel())
            .environmentObject(servicesAssembly.getCartManagerWrapper())
            .environmentObject(servicesAssembly.getLikesManagerWrapper())
    }
}
