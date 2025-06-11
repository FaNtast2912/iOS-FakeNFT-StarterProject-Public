//
//  EmptyNFTPlaceholderView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 30.05.2025.
//

import SwiftUI

struct EmptyNFTPlaceholderView: View {
    let isFavoriteCollection: Bool
    
    var body: some View {
        Text(isFavoriteCollection ? "У вас еще нет избранных NFT" : "У вас еще нет NFT" )
            .font(.system(size: 17, weight: .bold))
    }
}

#Preview {
    EmptyNFTPlaceholderView(isFavoriteCollection: true)
}
