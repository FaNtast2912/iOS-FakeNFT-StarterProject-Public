//
//  NavigationModel.swift
//  FakeNFT
//
//  Created by Kaider on 20.05.2025.
//

import SwiftUI

// MARK: - Экраны
enum Screens: Hashable {
    // Catalog
    case catalogListView
    case collectionDetailView
    
    // Nft(profile)
    case myNFTView
    case myFavoriteNFTView
    
    // Statistics
    case statisticsView
    case userCard
    case userCollection
    
    // Cart
    case cartView
    case paymentMethodView
    case paymentDoneView
    
    // WebView
    case webView(url: URL)
}

// MARK: - Модель навигации
@MainActor
final class NavigationModel: ObservableObject {
    @Published var path = [Screens]()
    @Published var selectedTab: Int = 0              // Текущий таб в TabView
    @Published var presentedScreen: Screens?         // Флаг для отображения модальных экранов
    @Published var selectedCollection: Collection?   // Выбранная коллекция для детального просмотра
    
    // MARK: - Навигационные методы
    
    /// Переход к новому экрану
    func navigate(to screen: Screens) {
        path.append(screen)
    }
    
    /// Переход к экрану деталей коллекции
    func navigateToCollectionDetail(collection: Collection) {
        selectedCollection = collection
        navigate(to: .collectionDetailView)
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
    func destination(for screen: Screens, with services: ServicesAssembly) -> some View {
        switch screen {
            
            // Catalog
        case .catalogListView:
            CatalogListView()
        case .collectionDetailView:
            if let collection = selectedCollection {
                CollectionDetailView(collection: collection)
            } else {
                Text("Коллекция не найдена")
                    .foregroundColor(.ypRedUniversal)
            }
            
            // Nft(profile)
        case .myNFTView:
            ProfileView(servicesAssembly: services)
        case .myFavoriteNFTView:
            MyFavoriteNFTView()
            
            // Statistics
        case .statisticsView:
            StatisticsView()
        case .userCard:
            UserCardView()
        case .userCollection:
            UserCollectionView()
            
            // Cart
        case .cartView:
            CartView()
        case .paymentMethodView:
            PaymentMethodView()
        case .paymentDoneView:
            PaymentDoneView()
            
            // WebView
        case .webView(let url):
            WebViewScreen(url: url)
        }
    }
}
