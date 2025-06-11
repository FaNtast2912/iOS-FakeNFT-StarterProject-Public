//
//  StatisticsViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import SwiftUI

struct StatisticsViewFactory: View {
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        StatisticsView(viewModel: servicesAssembly.makeStatisticsViewModel())
            .environmentObject(servicesAssembly.getCartManagerWrapper())
            .environmentObject(servicesAssembly.getLikesManagerWrapper())
    }
}
