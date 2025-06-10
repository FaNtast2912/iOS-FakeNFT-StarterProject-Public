//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//
import Foundation

@MainActor
final class UserCardViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    private let userService: UserByIdService
    
    init(userService: UserByIdService) {
        self.userService = userService
    }
    
    func loadUser(by id: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            user = try await userService.fetchUser(by: id)
        } catch {
            print("Ошибка загрузки пользователя: \(error)")
        }
    }

    func loadMockUser(user: User) {
        self.user = user
    }
}
