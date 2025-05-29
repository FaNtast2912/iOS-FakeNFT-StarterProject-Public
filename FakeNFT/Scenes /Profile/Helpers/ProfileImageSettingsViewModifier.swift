//
//  ProfileImageSettingsViewModifier.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//

import SwiftUI

struct ProfileImageSettingsViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70, alignment: .center)
            .clipShape(Circle())
        
    }
}

extension View {
    func profileImageViewStyle() -> some View {
        modifier(ProfileImageSettingsViewModifier())
    }
}
