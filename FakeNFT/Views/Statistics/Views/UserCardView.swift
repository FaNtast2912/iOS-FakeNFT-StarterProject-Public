//
//  UserCardView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct UserCardView: View {
    let userId: String
    @StateObject private var viewModel: UserCardViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    init(userId: String, viewModel: UserCardViewModel) {
        self.userId = userId
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseContentView(
            loadingState: viewModel.loadingState,
            onRetry: { Task { await viewModel.loadUser(by: userId) } }
        ) { user in
            userContent(user: user)
        }
        .navigationBarStyle(dismissAction: {
            navigationModel.navigateBack()
        })
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadUser(by: userId)
            }
        }
    }
    
    private func userContent(user: User) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: user.avatar)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ZStack {
                        Circle()
                            .stroke(Color.gray, lineWidth: 0.5)
                            .foregroundStyle(.gray)
                        Image("yp.emptyUserPick")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                
                Text(user.name)
                    .font(.system(size: 22, weight: .bold))
            }
            .padding(.bottom, 20)
            
            Text(user.description ?? "")
                .font(.system(size: 15))
                .padding(.trailing, 2)
                .padding(.bottom, 28)
            
            Button("Перейти на сайт пользователя") {
                navigationModel.IOScource()
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ypBlack))
            .cornerRadius(16)
            .font(.system(size: 15))
            .padding(.bottom, 40)
            
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
            
            Spacer()
        }
        .padding(.horizontal, AppConstants.UI.defaultPadding)
        .foregroundStyle(Color.ypBlack)
    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    return UserCardViewFactory(userId: "mock-user-id", servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}
