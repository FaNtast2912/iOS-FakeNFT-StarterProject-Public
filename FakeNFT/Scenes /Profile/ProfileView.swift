//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 25.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var profileVM: ProfileViewModel
    @State private var editProfileIsPresented: Bool = false
    
    init(servicesAssembly: ServicesAssembly) {
        _profileVM = StateObject(wrappedValue: ProfileViewModel(service: servicesAssembly))
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Image("yp.Edit")
                        .onTapGesture {
                            editProfileIsPresented.toggle()
                        }
                }
                
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: profileVM.profile.avatar)) { phase in
                        if let image = phase.image {
                            image
                                .profileImageViewStyle()
                        } else {
                            profileImagePlaceholder
                        }
                    }
                    
                    Text(profileVM.profile.name)
                        .font(.system(size: 22, weight: .bold))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(profileVM.profile.description ?? "")
                        .lineLimit(5)
                        .font(.system(size: 12, weight: .regular))
                        .frame(height: 72)
                    Button(profileVM.profile.website) {
                        if let url = URL(string: profileVM.profile.website) {
                            navigationModel.navigate(to: .webView(url: url))
                        }
                    }
                }
                .multilineTextAlignment(.leading)
                .padding(.bottom, 20)
                
                VStack {
                    ProfileListRowView(text: "Мои NFT" + " (\(profileVM.nftsCount))") {
                        navigationModel.navigate(to: .myNFTView)
                    }
                    
                    ProfileListRowView(text: "Избранные NFT" + " (\(profileVM.nftLikesCount))") {
                        navigationModel.navigate(to: .myFavoriteNFTView)
                    }
                    
                    ProfileListRowView(text: "О Разработчике") {
                        
                    }
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 16)
            .sheet(isPresented: $editProfileIsPresented) {
                ProfileEditView(profileVM: profileVM, service: profileVM.getService())
            }
            .task {
                    await profileVM.fetchProfile()
            }
            .alert( isPresented: $profileVM.alertErrorPresented) {
                Alert(
                    title: Text("Не удалось получить данные"),
                    primaryButton: .default(Text("Отмена")),
                    secondaryButton: .cancel(Text("Повторить"), action: {
                        Task {
                            await profileVM.fetchProfile()
                        }
                    })
                )
            }
            
            ProgressHUD(isLoading: profileVM.loadingState == .loading)
                .opacity(profileVM.loadingState == .loading ? 1 : 0)
        }
    }
    
    private var profileImagePlaceholder: some View {
        ZStack {
            Circle().stroke(Color.gray, lineWidth: 0.5)
                .foregroundStyle(.gray)
            Image(profileVM.avatarPlaceholderName)
                .profileImageViewStyle()
        }
        .frame(width: 70, height: 70)
    }
}

#Preview {
    ProfileView(servicesAssembly: ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
        .environmentObject(NavigationModel())
}
