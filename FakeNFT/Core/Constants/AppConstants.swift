//
//  AppConstants.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import Foundation

enum AppConstants {
    enum UI {
        static let defaultCornerRadius: CGFloat = 12
        static let defaultPadding: CGFloat = 16
        static let defaultSpacing: CGFloat = 8
    }
    
    enum Network {
        static let defaultTimeoutInterval: TimeInterval = 30
        static let maxRetryAttempts = 3
    }
}
