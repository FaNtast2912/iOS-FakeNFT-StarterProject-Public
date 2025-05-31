//
//  ProfileListRowView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//

import SwiftUI

struct ProfileListRowView: View {
    let text: String
    let completion: () -> Void
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .onTapGesture {
            completion()
        }
        .font(.system(size: 17, weight: .bold))
        .padding(.vertical, 20)
    }
}

#Preview {
    ProfileListRowView(text: "Row", completion: { print("tap row") })
}
