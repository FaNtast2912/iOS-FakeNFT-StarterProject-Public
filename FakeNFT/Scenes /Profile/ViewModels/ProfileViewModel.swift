//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: Profile
    @Published var loadingState: LoadingState = .loaded
    @Published var avatarPlaceholderName = "yp.emptyUserPick"
    @Published var alertErrorPresented: Bool = false
    @Published var nftsCount: Int = 0
    @Published var nftLikesCount: Int = 0
    private let service: ServicesAssembly
    
    enum LoadingState {
        case loading
        case loaded
        case error
    }
    
    init(service: ServicesAssembly) {
        self.service = service
        profile = Profile(name: "Имя", avatar: "", description: "Описание", website: "Сайт", nfts: [], likes: [], id: "")
        
        Task {
            await fetchProfile()
        }
    }
    
    func updateMockProfile(name: String, avatar: String, description: String, website: String) {
        let newProfile = Profile(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nfts: self.profile.nfts,
            likes: self.profile.likes,
            id: self.profile.id
        )
        profile = newProfile
    }
    
    func fetchProfile() async {
        loadingState = .loading
        do {
            profile = try await service.profileService.fetchProfile()
            nftsCount = profile.nfts.count
            nftLikesCount = profile.likes.count
            loadingState = .loaded
        } catch {
            loadingState = .error
            alertErrorPresented = loadingState == .error ? true : false
            print(String(describing: error.localizedDescription))
        }
    }
    
    func getService() -> ServicesAssembly {
        return service
    }
    
}
