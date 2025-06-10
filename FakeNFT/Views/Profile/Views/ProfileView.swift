//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 25.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var editProfileIsPresented: Bool = false
    
    init(viewModel: ProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BaseContentView(
                loadingState: viewModel.loadingState,
                onRetry: { Task { await viewModel.loadData() } }
            ) { profile in
                profileContent(profile: profile)
            }
        }
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadData()
            }
        }
        .alert("Не удалось получить данные", isPresented: $viewModel.alertErrorPresented) {
            Button("Отмена", role: .cancel) {}
            Button("Повторить") {
                Task { await viewModel.loadData() }
            }
        }
        .sheet(isPresented: $editProfileIsPresented) {
            ProfileEditViewFactory(
                profile: viewModel.profile,
                servicesAssembly: viewModel.servicesAssembly
            )
        }
    }
    
    private func profileContent(profile: Profile) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Image(.ypEdit)
                    .onTapGesture {
                        editProfileIsPresented.toggle()
                    }
            }
            
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: profile.avatar)) { phase in
                    if let image = phase.image {
                        image.profileImageViewStyle()
                    } else {
                        profileImagePlaceholder
                    }
                }
                
                Text(profile.name)
                    .font(.system(size: 22, weight: .bold))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(profile.description ?? "")
                    .lineLimit(5)
                    .font(.system(size: 12, weight: .regular))
                    .frame(height: 72)
                
                Button {
                    if let url = URL(string: profile.website) {
                        navigationModel.navigate(to: .webView(url: url))
                    }
                } label: {
                    Text(profile.website)
                        .multilineTextAlignment(.leading)
                }
            }
            .multilineTextAlignment(.leading)
            .padding(.bottom, 20)
            
            VStack {
                ProfileListRowView(text: "Мои NFT (\(viewModel.nftsCount))") {
                    navigationModel.navigate(to: .myNFTView)
                }
                
                ProfileListRowView(text: "Избранные NFT (\(viewModel.nftLikesCount))") {
                    navigationModel.navigate(to: .myFavoriteNFTView)
                }
                
                ProfileListRowView(text: "О Разработчике") {
                    if let url = URL(string: viewModel.developerWebsite) {
                        navigationModel.navigate(to: .webView(url: url))
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, AppConstants.UI.defaultPadding)
    }
    
    private var profileImagePlaceholder: some View {
        ZStack {
            Circle().stroke(Color.gray, lineWidth: 0.5)
                .foregroundStyle(.gray)
            Image(viewModel.avatarPlaceholderName)
                .profileImageViewStyle()
        }
        .frame(width: 70, height: 70)
    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    return ProfileViewFactory(servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}

