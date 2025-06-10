//
//  UserCollectionViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct UserCollectionViewFactory: View {
    let user: User
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        UserCollectionView(
            user: user,
            viewModel: servicesAssembly.makeUserCollectionViewModel()
        )
    }
}
