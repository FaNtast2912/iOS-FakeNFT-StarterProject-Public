//
//  UserCardView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct UserCardView: View {
    let user: User
    @StateObject private var viewModel = UserCardViewModel()
    @EnvironmentObject var navigationModel: NavigationModel

    var body: some View {
        contentView
            .foregroundStyle(Color.ypBlack)
            .padding(16)
            .navigationBarStyle(dismissAction: {
                navigationModel.navigateBack()
            })
            .onAppear {
                viewModel.loadMockUser(user: user)
            }
    }

    // MARK: - Content View

    @ViewBuilder
    private var contentView: some View {
        if let user = viewModel.user {
            VStack(alignment: .leading) {
                userHeaderView(user: user)
                userDescriptionView(user: user)
                websiteButtonView(user: user)
                nftCollectionHeaderView(user: user)
                Spacer()
            }
        } else {
            Text("Загрузка...")
        }
    }

    private func userHeaderView(user: User) -> some View {
        HStack(spacing: 16) {
            Image("yp.userPickMock")
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())

            Text(user.name)
                .font(.system(size: 22, weight: .bold))
        }
        .padding(.bottom, 20)
    }

    private func userDescriptionView(user: User) -> some View {
        Text(user.description)
            .font(.system(size: 15))
            .padding(.trailing, 2)
            .padding(.bottom, 28)
        
    }

    private func websiteButtonView(user: User) -> some View {
        Button("Перейти на сайт пользователя") {
            // будет обработка позже
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ypBlack))
        .cornerRadius(16)
        .font(.system(size: 15))
        .padding(.bottom, 40)
    }

    private func nftCollectionHeaderView(user: User) -> some View {
        HStack {
            Text("Коллекция NFT (\(user.nfts.count))")
                .font(.system(size: 22, weight: .bold))
            Spacer()
            Image("yp.chevron.backward")
                .rotationEffect(.degrees(180))
        }
        .onTapGesture {
            navigationModel.navigate(to: .userCollection(user: user))
        }
    }
}

#Preview {
    UserCardView(
        user: User(
            id: "1",
            name: "Mock User",
            avatar: "",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "https://example.com",
            nfts: ["nft1", "nft2"],
            rating: "3"
            
        )
    )
}
