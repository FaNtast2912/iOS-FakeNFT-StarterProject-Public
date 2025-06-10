//
//  StatisticsViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//
import Foundation

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var sortOption: UsertSortOption = .initial {
        didSet {
            UserDefaults.standard.set(sortOption.rawValue, forKey: "userSortOption")
        }
    }
    @Published var isLoading = false

    private let userService: UserServiceProtocol

    init(userService: UserServiceProtocol) {
        self.userService = userService
        sortOption = .initial
    }

    func updateSortOption(_ option: UsertSortOption) {
        sortOption = option
    }

    func loadUsers() async {
        isLoading = true
        defer { isLoading = false }
        do {
            users = try await userService.fetchAllUsers()
        } catch {
            print("Ошибка загрузки пользователей: \(error)")
        }
    }

    var sortedUsers: [User] {
        SortingManagerUser.shared.sort(users: users, by: sortOption)
    }
}
