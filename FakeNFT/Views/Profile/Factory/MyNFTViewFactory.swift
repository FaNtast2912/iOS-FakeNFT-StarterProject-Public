//
//  MyNFTViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct MyNFTViewFactory: View {
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        MyNFTView(viewModel: servicesAssembly.makeMyNFTViewModel())
            .environmentObject(servicesAssembly.getCartManagerWrapper())
            .environmentObject(servicesAssembly.getLikesManagerWrapper())
    }
}
