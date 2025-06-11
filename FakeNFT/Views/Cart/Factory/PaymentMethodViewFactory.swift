//
//  PaymentMethodViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct PaymentMethodViewFactory: View {
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        PaymentMethodView(viewModel: servicesAssembly.makePaymentMethodViewModel())
            .environmentObject(servicesAssembly.getCartManagerWrapper())
            .environmentObject(servicesAssembly.getLikesManagerWrapper())
    }
}
