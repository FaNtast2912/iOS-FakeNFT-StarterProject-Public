//
//  Untitled.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//

import SwiftUI

struct StatisticsCell: View {
    let user: User
    let rank: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(rank)")
                .font(.system(size: 15))
            HStack {
                Image("yp.userPickMock")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                Text(user.name)
                Spacer()
                Text("\(user.rating)")
            }
            .padding(.horizontal, 16)
            .frame(height: 80)
            .font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.ypBlack)
            .background(Color.ypLightGrey)
            .cornerRadius(12)
        }
    }
}

#Preview {
    StatisticsCell(
        user: User(
            id: "1",
            name: "Mock User",
            avatar: "",
            description: "Bio",
            website: "https://example.com",
            nfts: ["nft1", "nft2"]
        ),
        rank: 1
    )
}
