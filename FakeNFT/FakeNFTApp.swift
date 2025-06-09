import SwiftUI

@main
struct FakeNFTApp: App {
    @StateObject private var navigation = NavigationModel()
    @StateObject private var cartManager = CartManager()
    @StateObject private var servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl())
    
    @StateObject private var cartViewModel: CartViewModel = {
        let networkClient = DefaultNetworkClient()
        let cartNetworkService = DefaultCartNetworkService(networkClient: networkClient)
        let nftStorage = NftStorageImpl()
        let servicesAssembly = ServicesAssembly(
            networkClient: networkClient,
            nftStorage: nftStorage
        )
        let cartManager = CartManager()
        
        return CartViewModel(
            cartManager: cartManager,
            cartNetworkService: cartNetworkService,
            nftService: servicesAssembly.nftService
        )
    }()

    var body: some Scene {
        WindowGroup {
            AppTabView(servicesAssembly: servicesAssembly)
                .environmentObject(navigation)
                .environmentObject(cartManager)
                .environmentObject(cartViewModel)
        }
    }
}
