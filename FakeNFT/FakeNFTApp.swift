import SwiftUI

@main
struct FakeNFTApp: App {
    @StateObject private var navigation = NavigationModel()
    @StateObject private var mockData = MockData()
    @StateObject private var paymentViewModel = PaymentMethodViewModel()

    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(navigation)
                .environmentObject(mockData)
                .environmentObject(paymentViewModel)
                .onAppear {
                    paymentViewModel.loadCurrencies(from: mockData)
                }
        }
    }
}
