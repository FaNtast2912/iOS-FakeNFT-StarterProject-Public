//
//  EditingProfileViewModel.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//

import Foundation

@MainActor
final class EditingProfileViewModel: BaseViewModel<Profile> {
    @Published var name: String
    @Published var description: String
    @Published var avatar: String
    @Published var website: String
    @Published var alertErrorPresented: Bool = false
    
    private var profileService: ProfileServiceProtocol {
        servicesAssembly.profileService
    }
    
    init(profile: Profile, servicesAssembly: ServicesAssembly) {
        self.name = profile.name
        self.description = profile.description ?? ""
        self.avatar = profile.avatar
        self.website = profile.website
        
        super.init(servicesAssembly: servicesAssembly)
        
        // Set initial state
        setLoaded(profile)
    }
    
    override func loadData() async {
        // Not used in this context - profile is passed in constructor
    }
    
    func updateAvatar() async {
        avatar = "https://lh6.ggpht.com/WeTiwh_IjTAP6F3Q3ECOh3OuXqdr28RVqB_K2o7dp51FRQsSqsODym2LJJ4IDyWugQ=w300"
    }
    
    func saveProfile() async {
        setLoading()
        
        let dto = UpdateProfileDto(avatar: avatar, name: name, description: description, website: website)
        
        do {
            let updatedProfile = try await profileService.updateProfile(dto: dto)
            setLoaded(updatedProfile)
        } catch {
            handleError(error)
            alertErrorPresented = true
        }
    }
}
