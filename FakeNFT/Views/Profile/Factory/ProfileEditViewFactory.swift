//
//  ProfileEditViewFactory.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import SwiftUI

struct ProfileEditViewFactory: View {
    let profile: Profile
    let servicesAssembly: ServicesAssembly
    
    var body: some View {
        ProfileEditView(
            viewModel: servicesAssembly.makeEditingProfileViewModel(profile: profile)
        )
    }
}
