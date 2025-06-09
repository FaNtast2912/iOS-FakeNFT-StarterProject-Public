//
//  MockUserService.swift
//  FakeNFT
//
//  Created by Анна Браун on 06.06.2025.
//
final class MockUserService: UserService {
    func fetchAllUsers() async throws -> [User] {
        return [
            User(
                id: "1",
                name: "Mitchell Acevedo",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы.",
                website: "https://student15.students.practicum.org",
                nfts: ["c"],
                rating: "1"
            ),
            User(
                id: "2",
                name: "Fred Hensley",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы.",
                website: "https://student4.students.practicum.org",
                nfts: ["a"],
                rating: "5"
            ),
            User(
                id: "3",
                name: "Evangelina Mullen",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы.",
                website: "https://example.com",
                nfts: ["a", "b", "c", "d"],
                rating: "4"
            )
        ]
    }
}
