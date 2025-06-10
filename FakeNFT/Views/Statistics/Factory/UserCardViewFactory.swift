//
//  UserCardViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct UserCardViewFactory: View {
    let userId: String
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        UserCardView(
            userId: userId,
            viewModel: servicesAssembly.makeUserCardViewModel()
        )
    }
}
