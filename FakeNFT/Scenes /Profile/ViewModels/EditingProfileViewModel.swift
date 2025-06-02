//
//  EditingProfileViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//

import Foundation

@MainActor
final class EditingProfileViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var avatar: String
    @Published var website: String
    @Published var loadingState: LoadingState = .loaded
    @Published var alertErrorPresented: Bool = false
    private let profileService: ProfileService
    
    enum LoadingState {
        case loading
        case loaded
        case error
    }
    
    init(
        name: String,
        description: String,
        avatar: String,
        website: String,
        service: ServicesAssembly
    ) {
        self.name = name
        self.description = description
        self.avatar = avatar
        self.website = website
        profileService = service.profileService
    }
    
    func updateAvatar() async {
        avatar = "https://lh6.ggpht.com/WeTiwh_IjTAP6F3Q3ECOh3OuXqdr28RVqB_K2o7dp51FRQsSqsODym2LJJ4IDyWugQ=w300"
    }
    
    func updateProfileInfo() async {
        let dto = UpdateProfileDto(avatar: avatar, name: name, description: description, website: website)
        loadingState = .loading
        do {
            _ = try await profileService.updateProfile(dto: dto)
            loadingState = .loaded
        } catch {
            loadingState = .error
            print(String(describing: error.localizedDescription))
        }
    }
}

