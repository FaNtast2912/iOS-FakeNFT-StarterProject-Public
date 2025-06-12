//
//  ArrayAsyncMap.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

extension Array where Element == String {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            try await values.append(transform(element))
        }
        return values
    }
}
