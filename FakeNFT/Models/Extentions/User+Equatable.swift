//
//  User+Equatable.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
