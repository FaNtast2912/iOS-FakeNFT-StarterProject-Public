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
    case settings
    case productDetails
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
}
    
// MARK: - Интеграция с Environment
    
/// Ключ для передачи NavigationModel через Environment
struct NavigationModelKey: EnvironmentKey {
    static var defaultValue: NavigationModel{
        fatalError("NavigationModel должен быть передан через environment!")
    }
}

extension EnvironmentValues {
    var navigationModel: NavigationModel {
        get {
            self[NavigationModelKey.self]
        } set {
            self[NavigationModelKey.self] = newValue
        }
    }
}

/// Модификатор для View
extension View {
    func withNavigationModel(_ model: NavigationModel) -> some View {
        environment(\.navigationModel, model)
    }
}
