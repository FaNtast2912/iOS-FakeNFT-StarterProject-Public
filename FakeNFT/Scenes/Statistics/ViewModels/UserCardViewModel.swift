//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//
import Foundation

final class UserCardViewModel: ObservableObject {
    @Published var user: Users?

    func loadMockUser(user: Users) {
        self.user = user
    }
}

