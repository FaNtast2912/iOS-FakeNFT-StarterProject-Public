//
//  StatisticsViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//
import Foundation

final class StatisticsViewModel: ObservableObject {
    @Published var users: [Users] = []

    init() {
        loadMockUsers()
    }

    private func loadMockUsers() {
        let mock: [Users] = [
            Users(
                id: "1",
                name: "Mitchell Acevedo",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                website: "https://student15.students.practicum.org",
                nfts: []
            ),
            Users(
                id: "2",
                name: "Fred Hensley",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                website: "https://student4.students.practicum.org",
                nfts: []
            ),
            Users(
                id: "3",
                name: "Evangelina Mullen",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                website: "https://example.com",
                nfts: ["a", "b"]
            )
        ]
        
        users = mock.sorted { $0.rating > $1.rating }
    }
}

