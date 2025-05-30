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
    
    enum LoadingState {
        case loading
        case loaded
        case error
    }
    
    init(
        name: String,
        description: String,
        avatar: String,
        website: String
    ) {
        self.name = name
        self.description = description
        self.avatar = avatar
        self.website = website
    }
    
    func updateAvatar() async {
        avatar = "https://sun9-71.userapi.com/impf/HXh-XOzRZNjBZN3-s3KY8-A1vvUZcCzEIVCO7A/NiLsvqlmqpI.jpg" + "?size=320x256&quality=96&sign=cae1cfe812481cab04191c25a4dda9c4&type=album"
    }
    
    func updateProfileInfo() async {
        do {
            loadingState = .loading
            try await Task.sleep(for: .seconds(3))
            print("данные отправились на сервер")
            loadingState = .loaded
        } catch {
            loadingState = .error
            alertErrorPresented = true
            print(error.localizedDescription)
        }
    }
    
}
