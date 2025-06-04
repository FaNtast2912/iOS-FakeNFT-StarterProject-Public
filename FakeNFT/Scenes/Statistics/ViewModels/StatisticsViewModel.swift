//
//  StatisticsViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//
import Foundation

final class StatisticsViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var sortOption: UsertSortOption = .initial {
        didSet {
            UserDefaults.standard.set(sortOption.rawValue, forKey: "userSortOption")
        }
    }
    
    var sortedUsers: [User] {
        SortingManagerUser.shared.sort(users: users, by: sortOption)
    }
    
    init() {
        loadSortOption()
        loadMockUsers()
    }
    
    func updateSortOption(_ option: UsertSortOption) {
        sortOption = option
    }
    
    private func loadSortOption() {
            if let raw = UserDefaults.standard.string(forKey: "userSortOption"),
               let option = UsertSortOption(rawValue: raw) {
                sortOption = option
            }
        }
    
    private func loadMockUsers() {
        let mock: [User] = [
            User(
                id: "1",
                name: "Mitchell Acevedo",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                website: "https://student15.students.practicum.org",
                nfts: ["c"],
                rating: "1"
            ),
            User(
                id: "2",
                name: "Fred Hensley",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                website: "https://student4.students.practicum.org",
                nfts: ["a"],
                rating: "5"
            ),
            User(
                id: "3",
                name: "Evangelina Mullen",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                website: "https://example.com",
                nfts: ["a", "b", "c", "d"],
                rating: "4"
            )
        ]
        
        users = mock
    }
}
