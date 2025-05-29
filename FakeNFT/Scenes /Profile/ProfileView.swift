//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 25.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @StateObject var profileVM = ProfileViewModel()
    @State private var editProfileIsPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Image("yp.Edit")
                    .onTapGesture {
                        editProfileIsPresented.toggle()
                    }
            }
            
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: profileVM.profile.avatar))
                    .profileImageViewStyle()
                Text(profileVM.profile.name)
                    .font(.system(size: 22, weight: .bold))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(profileVM.profile.description)
                    .lineLimit(5)
                    .font(.system(size: 12, weight: .regular))
                    .multilineTextAlignment(.leading)
                Button(profileVM.profile.website) {
                    print("tap on button")
                }
            }
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
            ProfileEditView(profileVM: profileVM)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(NavigationModel())
}
