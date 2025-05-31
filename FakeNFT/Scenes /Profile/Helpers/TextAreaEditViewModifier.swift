//
//  TextAreaEditViewModifier.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 29.05.2025.
//

import SwiftUI

struct TextAreaEditViewModifier: ViewModifier {
    let showError: Bool
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(.black)
            .padding()
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
            .overlay {
                if showError {
                    RoundedRectangle(cornerRadius: 12).strokeBorder(.red, lineWidth: 0.5)
                }
            }
    }
}

extension View {
    func profileTextViewStyle(showError: Bool = false) -> some View {
        modifier(TextAreaEditViewModifier(showError: showError))
    }
}
