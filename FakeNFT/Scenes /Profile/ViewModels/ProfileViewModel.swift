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
    
    init() {
        profile = Profile(
            name: "Joaquin Phoenix",
            avatar: "https://avatars.akamai.steamstatic.com/259ff9332254e10c5113cceeb7b5487c1cbd1d3d_full.jpg",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "Joaquin Phoenix.com",
            nfts: ["1", "2", "3", "4"],
            likes: ["1", "2", "3"],
            id: "1234fdgsd"
        )
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
    
    func fetchProfile() async throws {
        // реализовать реальный запрос
    }
}
