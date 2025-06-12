//
//  Untitled.swift
//  FakeNFT
//
//  Created by Анна Браун on 30.05.2025.
//
import SwiftUI

struct NavigationBarStyle: ViewModifier {
    var dismissAction: () -> Void

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: dismissAction) {
                        Image(.ypChevronBackward)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.ypBlack)
                    }
                }
            }
    }
}

extension View {
    func navigationBarStyle(dismissAction: @escaping () -> Void) -> some View {
        self.modifier(NavigationBarStyle(dismissAction: dismissAction))
    }
}
