//
//  UserLikesService.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 03.06.2025.

import Foundation

protocol UserLikesServiceProtocol {
    func fetchLikes() async throws -> UserLikes
    func updateLikes(dto: Dto) async throws -> UserLikes
}

