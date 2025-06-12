//
//  Profile+Equatable.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

extension Profile: Equatable {
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.id == rhs.id
    }
}
