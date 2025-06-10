//
//  ProfileEditView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//

import SwiftUI

struct ProfileEditView: View {
    @StateObject private var viewModel: EditingProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: EditingProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                avatarSection
                formFields
                Spacer()
            }
            .padding(.horizontal, AppConstants.UI.defaultPadding)
            .toolbar(.hidden, for: .navigationBar)
            .alert("Не удалось обновить данные", isPresented: $viewModel.alertErrorPresented) {
                Button("Отмена", role: .cancel) {}
                Button("Повторить") {
                    Task {
                        await viewModel.saveProfile()
                        dismiss()
                    }
                }
            }
            
            // Loading overlay
            if viewModel.loadingState.isLoading {
                ProgressHUD(isLoading: true)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            Button {
                Task {
                    await viewModel.saveProfile()
                    dismiss()
                }
            } label: {
                Image("yp.close")
            }
            .padding(.top, 16)
            .foregroundStyle(Color.ypBlack)
            .disabled(
                viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                viewModel.website.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                viewModel.loadingState.isLoading
            )
        }
        .padding(.bottom, 22)
    }
    
    private var avatarSection: some View {
        VStack {
            ZStack {
                AsyncImage(url: URL(string: viewModel.avatar)) { image in
                    image.profileImageViewStyle()
                } placeholder: {
                    ZStack {
                        Circle()
                            .foregroundStyle(.gray)
                            .frame(width: 70, height: 70)
                    }
                }
                Text("Сменить фото")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(Color.ypWhite)
            .frame(width: 70, height: 70)
            
            Button("Загрузить изображение") {
                Task {
                    await viewModel.updateAvatar()
                }
            }
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(Color.ypBlack)
        }
    }
    
    private var formFields: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Имя")
                TextField("Имя", text: $viewModel.name)
                    .profileTextViewStyle(
                        showError: viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Описание")
                TextField("Описание", text: $viewModel.description, axis: .vertical)
                    .lineLimit(5, reservesSpace: true)
                    .profileTextViewStyle()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Сайт")
                TextField("Сайт", text: $viewModel.website)
                    .profileTextViewStyle(
                        showError: viewModel.website.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
            }
        }
        .font(.system(size: 22, weight: .bold))
    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    let mockProfile = Profile(
        name: "Mock User",
        avatar: "https://example.com/avatar.jpg",
        description: "Mock description",
        website: "https://example.com",
        nfts: ["1", "2"],
        likes: ["1"],
        id: "1"
    )
    return ProfileEditViewFactory(profile: mockProfile, servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}
