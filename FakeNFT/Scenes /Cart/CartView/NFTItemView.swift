//
//  NFTItemView.swift
//  FakeNFT
//
//  Created by Kaider on 27.05.2025.
//

import SwiftUI

struct NFTItemView: View {
    let nft: Nft
    let onDeleteTap: () -> Void
    
    private var nftImage: String {
        let images = ["mockImageNFT", "mockImageNFT2", "mockImageNFT3"]
        guard !images.isEmpty else { return "mockImageNFT" }
        let index = abs(Int(nft.id) ?? 0) % images.count
        return images[index]
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(nftImage)
                .resizable()
                .frame(width: 108, height: 108)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(nft.name)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(2)
                
                RatingView(rating: nft.rating)
                
                Text("Цена")
                    .font(.system(size: 13, weight: .regular))
                    .padding(.top, 12)
                
                Text(String(format: "%.2f ETH", Double(nft.price)))
                    .font(.system(size: 17, weight: .bold))
            }
            
            Spacer()
            
            Button(action: onDeleteTap) {
                Image("yp.cart.delete")
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
            }
        }
        .padding(.vertical, 8)
    }
}

struct RatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                Image(systemName: index < rating ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    let mockNFT = Nft(
        id: "1",
        name: "April",
        createdAt: "2025-05-31",
        images: [],
        rating: 4,
        description: "Описание тестового NFT",
        price: 1.78,
        author: "Автор"
    )
    
    NFTItemView(
        nft: mockNFT,
        onDeleteTap: {
            print("Delete tapped")
        }
    )
    .padding()
}
