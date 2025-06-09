import SwiftUI

@main
struct FakeNFTApp: App {
    @StateObject private var navigation = NavigationModel()
    @StateObject private var servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl())
    
    @StateObject private var cartViewModel: CartViewModel = {
        let networkClient = DefaultNetworkClient()
        let cartNetworkService = DefaultCartNetworkService(networkClient: networkClient)
        let nftStorage = NftStorageImpl()
        let servicesAssembly = ServicesAssembly(
            networkClient: networkClient,
            nftStorage: nftStorage
        )
        
        return CartViewModel(
            cartNetworkService: cartNetworkService,
            nftService: servicesAssembly.nftService
        )
    }()

    var body: some Scene {
        WindowGroup {
            AppTabView(servicesAssembly: servicesAssembly)
                .environmentObject(navigation)
                .environmentObject(cartViewModel)
        }
    }
}
