//
//  UserCardView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct UserCardView: View {
    let user: Users
    @StateObject private var viewModel = UserCardViewModel()
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = viewModel.user {
                HStack(spacing: 16) {
                    Image("yp.userPickMock")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    
                    Text(user.name)
                        .font(.system(size: 22, weight: .bold))
                }
                .padding(.bottom, 20)
                
                Text(user.description)
                    .padding(.bottom, 28)
                    .padding(.trailing, 2)
                    .font(.system(size: 15))
                
                Button("Перейти на сайт пользователя") {
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ypBlack))
                .cornerRadius(16)
                .padding(.bottom, 40)
                .font(.system(size: 15))
                
                HStack {
                    Text("Коллекция NFT (\(user.nfts.count))")
                        .font(.system(size: 22, weight: .bold))
                    Spacer()
                    Image("yp.chevron.backward")
                        .rotationEffect(.degrees(180))
                }
                Spacer()
            } else {
                Text("Загрузка...") //временно, потом будет сетевой запрос и обработка с прогрессхад
            }
        }
        .foregroundStyle(Color.ypBlack)
        .padding()
        .onAppear {
            viewModel.loadMockUser(user: user)
        }
        // тоже временно потом вынесем в общие стили
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationModel.navigateBack()
                }) {
                    HStack(spacing: 4) {
                        Image("yp.chevron.backward")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    UserCardView(
        user: Users(
            id: "1",
            name: "Mock User",
            avatar: "",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "https://example.com",
            nfts: ["nft1", "nft2"]
        )
    )
}
