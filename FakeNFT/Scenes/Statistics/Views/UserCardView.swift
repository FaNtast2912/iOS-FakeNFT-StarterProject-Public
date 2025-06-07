//
//  UserCardView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct UserCardView: View {
    private let userId: String
    @StateObject private var viewModel: UserCardViewModel
    @EnvironmentObject var navigationModel: NavigationModel
    
    init(userId: String, userService: UserByIdService) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: UserCardViewModel(userService: userService))
    }
    
    var body: some View {
        contentView
            .foregroundStyle(Color.ypBlack)
            .padding(16)
            .navigationBarStyle(dismissAction: {
                navigationModel.navigateBack()
            })
            .onAppear {
                if viewModel.user == nil {
                    Task {
                        await viewModel.loadUser(by: userId)
                    }
                }
            }
    }
    
    // MARK: - Content View
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            Spacer()
            .progressHUD(isLoading: viewModel.isLoading)
            Spacer()
        } else if let user = viewModel.user {
            VStack(alignment: .leading) {
                userHeaderView(user: user)
                userDescriptionView(user: user)
                websiteButtonView(user: user)
                nftCollectionHeaderView(user: user)
                Spacer()
            }
        } else {
            Text("Пользователь не найден")
                .foregroundColor(Color.ypBlack)
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private func userHeaderView(user: User) -> some View {
        HStack(spacing: 16) {
            if !user.avatar.isEmpty, let url = URL(string: user.avatar) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    default:
                        Image("yp.emptyUserPick")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .opacity(0.5)
                    }
                }
            } else {
                Image("yp.userPickMock")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .opacity(0.5)
            }
            
            Text(user.name)
                .font(.system(size: 22, weight: .bold))
        }
        .padding(.bottom, 20)
    }
    
    private func userDescriptionView(user: User) -> some View {
        Text(user.description ?? "")
            .font(.system(size: 15))
            .padding(.trailing, 2)
            .padding(.bottom, 28)
    }
    
    private func websiteButtonView(user: User) -> some View {
        Button("Перейти на сайт пользователя") {
                navigationModel.IOScource() // добавила единый так как у большинста юзеров ссылка на сайт нерабочая приходит с сервера 
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
        userId: "1",
        userService: MockUserByIdService()
    )
}
