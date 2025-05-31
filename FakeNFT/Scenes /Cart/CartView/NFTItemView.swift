//
//  NFTItemView.swift
//  FakeNFT
//
//  Created by Kaider on 27.05.2025.
//

import SwiftUI

struct NFTItemView: View {
    @EnvironmentObject var mockData: MockData
    
    let nft: CartNFT
    
    var body: some View {
        HStack(spacing: 16) {
            Image("mockImageNFT")
                .resizable()
                .frame(width: 108, height: 108)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(nft.name)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < 4 ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.yellow)
                    }
                }
                
                Text("Цена")
                    .font(.system(size: 13, weight: .regular))
                    .padding(.top, 12)
                
                Text(String(format: "%.2f ETH", nft.price))
                    .font(.system(size: 17, weight: .bold))
            }
            
            Spacer()
            
            Button(action: {
                // TODO: Добавить логику удаления NFT из корзины
                print("Удален NFT: \(nft.name)")
            }, label: {
                Image("yp.cart.delete")
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
            })
        }
    }
}

#Preview {
    let mockNFT = CartNFT(name: "April", price: 1.78, imageUrl: nil)
    NFTItemView(nft: mockNFT)
        .environmentObject(MockData())
}
