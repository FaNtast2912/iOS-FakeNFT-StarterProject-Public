//
//  ProfileEditView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//

import SwiftUI

struct ProfileEditView: View {
    @StateObject private var profileEditVM: EditingProfileViewModel
    @ObservedObject private var profileVM: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(profileVM: ProfileViewModel) {
        self.profileVM = profileVM
        _profileEditVM = StateObject(wrappedValue: EditingProfileViewModel(
            name: profileVM.profile.name,
            description: profileVM.profile.description,
            avatar: profileVM.profile.avatar,
            website: profileVM.profile.website
        ))
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        Task {
                            await profileEditVM.updateProfileInfo()
                            profileVM.updateMockProfile(
                                name: profileEditVM.name,
                                avatar: profileEditVM.avatar,
                                description: profileEditVM.description,
                                website: profileEditVM.website
                            )
                            dismiss()
                        }
                    } label: {
                        Image("yp.close")
                    }
                    .padding(.top, 16)
                    .foregroundStyle(Color.ypBlack)
                    .disabled(profileEditVM.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || profileEditVM.website.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.bottom, 22)
                
                VStack {
                    ZStack {
                        AsyncImage(url: URL(string: profileEditVM.avatar))
                            .profileImageViewStyle()
                        
                        Text("Сменить фото")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(Color.ypWhite)
                    .frame(width: 70, height: 70)
                    
                    Button("Загрузить изображение") {
                        Task {
                            await profileEditVM.updateAvatar()
                        }
                    }
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color.ypBlack)
                }
                
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Имя")
                        TextField("Имя", text: $profileEditVM.name)
                            .profileTextViewStyle(showError: profileEditVM.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Описание")
                        TextField("Описание", text: $profileEditVM.description, axis: .vertical)
                            .lineLimit(5, reservesSpace: true)
                            .profileTextViewStyle()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Сайт")
                        TextField("Сайт", text: $profileEditVM.website)
                            .profileTextViewStyle(showError: profileEditVM.website.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .font(.system(size: 22, weight: .bold))
                Spacer()
            }
            .padding(.horizontal, 16)
            .toolbar(.hidden, for: .navigationBar)
            .alert( isPresented: $profileEditVM.alertErrorPresented) {
                Alert(
                    title: Text("Не удалось обновить данные"),
                    primaryButton: .default(Text("Отмена")),
                    secondaryButton: .cancel(Text("Повторить"), action: {
                        Task {
                            await profileEditVM.updateProfileInfo()
                            profileVM.updateMockProfile(
                                name: profileEditVM.name,
                                avatar: profileEditVM.avatar,
                                description: profileEditVM.description,
                                website: profileEditVM.website
                            )
                            dismiss()
                        }
                    })
                )
            }
            
            if profileEditVM.loadingState == .loading {
                ProgressHUD(isLoading: profileEditVM.loadingState == .loading)
            }
        }
        
    }
}

#Preview {
    ProfileEditView(profileVM: ProfileViewModel())
}
