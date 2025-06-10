//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 03.06.2025.

import Foundation

protocol ProfileService {
    func fetchProfile() async throws -> Profile
    func updateProfile(dto: Dto) async throws -> Profile
}

