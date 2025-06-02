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
                        } else if phase.error != nil {
                            profileImagePlaceholder
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
                        print("tap on button")
                    }
                }
                .multilineTextAlignment(.leading)
                .padding(.bottom, 20)
                
                VStack {
                    ProfileListRowView(text: "Мои NFT" + " (\(profileVM.profile.nfts.count))") {
                        
                    }
                    
                    ProfileListRowView(text: "Избранные NFT" + " (\(profileVM.profile.likes.count))") {
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
            
            if profileVM.loadingState == .loading {
                ProgressHUD(isLoading: profileVM.loadingState == .loading)
            }
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
