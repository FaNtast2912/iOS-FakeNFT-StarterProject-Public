//
//  MockUserCardService.swift
//  FakeNFT
//
//  Created by Анна Браун on 06.06.2025.
//
import Foundation

final class MockUserByIdService: UserByIdServiceProtocol {
        func fetchUser(by id: String) async throws -> User {
            try await Task.sleep(nanoseconds: 500_000_000)
            return User(
                id: id,
                name: "Mock User",
                avatar: "",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы.",
                website: "https://example.com",
                nfts: ["nft1", "nft2"],
                rating: "3"
            )
        }
    }

