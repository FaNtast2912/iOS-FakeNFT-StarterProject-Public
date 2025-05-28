//
//  NavigationModel.swift
//  FakeNFT
//
//  Created by Kaider on 20.05.2025.
//

import SwiftUI

// MARK: - Экраны
enum Screens: Hashable {
    case catalog
    case nftDetails
    case profile
    case favorites
    case statistics
    case productDetails
    case webView(url: URL)
}

// MARK: - Модель навигации
@MainActor
final class NavigationModel: ObservableObject {
    @Published var path = [Screens]()
    @Published var selectedTab: Int = 0              // Текущий таб в TabView
    @Published var presentedScreen: Screens?         // Флаг для отображения модальных экранов
    
    // MARK: - Навигационные методы
    
    /// Переход к новому экрану
    func navigate(to screen: Screens) {
        path.append(screen)
    }
    
    /// Возврат на предыдущий экран
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Возврат к корню навигационного стека
    func navigateToRoot() {
        path.removeAll()
    }
    
    // MARK: - Управление табами
    
    func switchToTab(_ index: Int) {
        selectedTab = index
    }
    
    // MARK: - Модальные экраны
    
    /// Показать экран модально
    func presentScreen(_ screen: Screens) {
        presentedScreen = screen
    }
    
    /// Закрыть модальный экран
    func dismissPresentedScreen() {
        presentedScreen = nil
    }
    
    func openPracticumTerms() {
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") {
            navigate(to: .webView(url: url))
        }
    }
    
    func IOScource() {
        if let url = URL(string: "https://practicum.yandex.ru/ios-developer/?from=catalog") { // экран "Подробнее об авторе"
            navigate(to: .webView(url: url))
        }
    }
}

// MARK: - Обработка переходов

extension NavigationModel {
    @ViewBuilder
    func destination(for screen: Screens) -> some View {
        switch screen {
        case .catalog:
            CatalogView()
        case .nftDetails:
            Text("NFT Details") // placeholder
        case .profile:
            ProfileView()
        case .favorites:
            Text("favorites") // placeholder
        case .statistics:
            StatisticsView()
        case .productDetails:
            Text("productDetails") // placeholder
        case .webView(let url):
            WebViewScreen(url: url)
        }
    }
}
