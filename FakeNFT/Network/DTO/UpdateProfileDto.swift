//
//  UpdateProfileDto.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

struct UpdateProfileDto: Dto {
    var avatar: String
    var name: String
    var description: String
    var website: String

    private enum ProfileKeys: String {
        case avatar, name, description, website
    }

    func asDictionary() -> [String: String] {
        [ProfileKeys.avatar.rawValue: avatar,
         ProfileKeys.name.rawValue: name,
         ProfileKeys.description.rawValue: description,
         ProfileKeys.website.rawValue: website]
    }
}
