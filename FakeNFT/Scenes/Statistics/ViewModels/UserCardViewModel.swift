//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//
import Foundation

final class UserCardViewModel: ObservableObject {
    @Published var user: User?

    func loadMockUser(user: User) {
        self.user = user
    }
}

