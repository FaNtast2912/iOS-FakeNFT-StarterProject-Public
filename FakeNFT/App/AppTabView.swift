//
//  AppTabView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 25.05.2025.
//

import SwiftUI

struct AppTabView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @ObservedObject private var servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        tabBarAppearance.backgroundColor = UIColor(.ypWhite)
        
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.ypBlack)
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.ypBlack)
        
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.ypBlueUniversal)
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.ypBlueUniversal)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = UIColor(Color.ypBlueUniversal)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.ypBlack)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            TabView(selection: $navigationModel.selectedTab) {
                ProfileViewFactory(servicesAssembly: servicesAssembly)
                    .tabItem {
                        Text("Профиль")
                        Image("yp.profileIcon")
                            .renderingMode(.template)
                    }
                    .tag(0)
                
                CatalogListViewFactory(servicesAssembly: servicesAssembly)
                    .tabItem {
                        Text("Каталог")
                        Image("yp.catalogIcon")
                            .renderingMode(.template)
                    }
                    .tag(1)
                
                CartViewFactory(servicesAssembly: servicesAssembly)
                    .tabItem {
                        Text("Корзина")
                        Image("yp.cartIcon")
                            .renderingMode(.template)
                    }
                    .tag(2)
                
                StatisticsViewFactory(servicesAssembly: servicesAssembly)
                    .tabItem {
                        Text("Статистика")
                        Image("yp.statisticsIcon")
                            .renderingMode(.template)
                    }
                    .tag(3)
            }
            .navigationDestination(for: Screens.self) { screen in
                navigationModel.destination(for: screen, with: servicesAssembly)
            }
            .environmentObject(servicesAssembly.getCartManagerWrapper())
            .environmentObject(servicesAssembly.getLikesManagerWrapper())
            .onChange(of: navigationModel.selectedTab) { oldTab, newTab in
                Task {
                    await syncManagersOnTabChange(newTab: newTab)
                }
            }
        }
        .task {
            // Загружаем начальные данные при старте приложения
            await loadInitialData()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadInitialData() async {
        async let loadCart: Void = servicesAssembly.getCartManagerWrapper().loadCart()
        async let loadLikes: Void = servicesAssembly.getLikesManagerWrapper().loadLikes()
        
        await loadCart
        await loadLikes
    }
    
    /// Синхронизация менеджеров при переключении табов
    private func syncManagersOnTabChange(newTab: Int) async {
        let cartWrapper = servicesAssembly.getCartManagerWrapper()
        let likesWrapper = servicesAssembly.getLikesManagerWrapper()
        
        switch newTab {
        case 0: // Профиль
            // Обновляем лайки для отображения любимых NFT
            likesWrapper.refresh()
            
        case 1: // Каталог
            // Обновляем оба менеджера для актуальных состояний кнопок
            async let refreshCart: Void = cartWrapper.loadCart()
            async let refreshLikes: Void = likesWrapper.loadLikes()
            
            await refreshCart
            await refreshLikes
            
        case 2: // Корзина
            // Обязательно обновляем корзину для отображения новых товаров
            cartWrapper.refresh()
            // Также обновляем лайки для корректного отображения состояния
            likesWrapper.refresh()
            
        case 3: // Статистика
            // Обновляем лайки для статистики
            likesWrapper.refresh()
            
        default:
            print("❓ Неизвестный таб: \(newTab)")
        }

    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    let navigationModel = NavigationModel()
    return AppTabView(
        servicesAssembly: mockServices
    )
    .environmentObject(navigationModel)
}
