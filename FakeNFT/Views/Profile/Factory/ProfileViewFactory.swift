//
//  ProfileViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct ProfileViewFactory: View {
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        ProfileView(viewModel: servicesAssembly.makeProfileViewModel())
    }
}
