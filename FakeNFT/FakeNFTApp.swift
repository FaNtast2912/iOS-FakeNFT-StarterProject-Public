import SwiftUI

@main
struct FakeNFTApp: App {
    @StateObject private var navigation = NavigationModel()
    @StateObject private var mockData = MockData()
    @StateObject private var cartManager = CartManager()
    @StateObject private var paymentViewModel: PaymentMethodViewModel = {
        let mockCurrencies = MockData().paymentCryptos
        return PaymentMethodViewModel(currencies: mockCurrencies)
    }()
    
    private var cartViewModel: CartViewModel {
        CartViewModel(cartManager: cartManager)
    }

    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(navigation)
                .environmentObject(mockData)
                .environmentObject(cartManager)
                .environmentObject(cartViewModel)
                .environmentObject(paymentViewModel)
        }
    }
}
