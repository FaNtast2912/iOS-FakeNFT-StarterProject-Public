//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//
import Foundation

@MainActor
final class ProfileViewModel: BaseViewModel<Profile> {
    @Published var avatarPlaceholderName = "yp.emptyUserPick"
    @Published var alertErrorPresented: Bool = false
    @Published var nftsCount: Int = 0
    @Published var nftLikesCount: Int = 0
    @Published var developerWebsite = "https://practicum.yandex.ru/ios-developer/"
    
    private var profileService: ProfileServiceProtocol {
        servicesAssembly.profileService
    }
    
    // Computed property for easy access to profile
    var profile: Profile {
        return loadingState.data ?? Profile(
            name: "Имя", avatar: "", description: "Описание",
            website: "Сайт", nfts: [], likes: [], id: ""
        )
    }
    
    override func loadData() async {
        setLoading()
        
        do {
            let profile = try await profileService.fetchProfile()
            nftsCount = profile.nfts.count
            nftLikesCount = profile.likes.count
            setLoaded(profile)
        } catch {
            handleError(error)
            alertErrorPresented = true
        }
    }
    
    func updateProfile(name: String, avatar: String, description: String, website: String) async {
        let dto = UpdateProfileDto(avatar: avatar, name: name, description: description, website: website)
        
        do {
            let updatedProfile = try await profileService.updateProfile(dto: dto)
            nftsCount = updatedProfile.nfts.count
            nftLikesCount = updatedProfile.likes.count
            setLoaded(updatedProfile)
        } catch {
            handleError(error)
            alertErrorPresented = true
        }
    }
}
