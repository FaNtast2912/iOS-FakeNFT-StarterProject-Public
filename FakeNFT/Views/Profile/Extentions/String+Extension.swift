//
//  String+Extension.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 06.06.2025.
//

import Foundation

extension String {
    func correctAuthorName(with prefix: String, ending: String) -> Self {
        let first = trimmingPrefix(prefix)
        let firstIndex = firstIndex(of: "_") ?? endIndex
        let firstName = first[..<firstIndex]
        var secondName = first[firstIndex...].trimmingPrefix("_")
        if let rangeToRemove = secondName.range(of: ending) {
            secondName.removeSubrange(rangeToRemove)
        }
        
        return firstName.capitalized + " " + secondName.capitalized
    }
}
