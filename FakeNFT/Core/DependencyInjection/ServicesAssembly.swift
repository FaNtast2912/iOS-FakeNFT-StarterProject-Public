import Foundation

final class ServicesAssembly: ObservableObject {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    // Lazy-инициализация менеджеров
    private lazy var _likesManager = LikesManager(userLikesService: userLikesService)
    private lazy var _cartManager = CartManager(cartNetworkService: cartNetworkService)
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }
    
    var nftService: NftServiceProtocol {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var catalogService: CatalogServiceProtocol {
        CatalogServiceImpl(networkClient: networkClient)
    }
    
    var profileService: ProfileServiceProtocol {
        ProfileServiceImpl(networkClient: networkClient)
    }
    
    var userLikesService: UserLikesServiceProtocol {
        UserLikesServiceImpl(networkClient: networkClient)
    }
    
    var cartNetworkService: CartNetworkServiceProtocol {
        CartNetworkServiceImpl(networkClient: networkClient)
    }
    
    var likesManager: LikesManager {
        return _likesManager
    }
    
    var cartManager: CartManager {
        return _cartManager
    }
    
    var userService: UserServiceProtocol {
        UserServiceImpl(
            networkClient: networkClient
        )
    }
    var userByIdService: UserByIdServiceProtocol {
        UserByIdServiceImpl(
            networkClient: networkClient
        )
    }
}

extension ServicesAssembly {
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(servicesAssembly: self)
    }
    
    func makeMyNFTViewModel() -> MyNFTViewModel {
        MyNFTViewModel(servicesAssembly: self)
    }
    
    func makeMyFavoriteNFTViewModel() -> MyFavoriteNFTViewModel {
        MyFavoriteNFTViewModel(servicesAssembly: self)
    }
    
    func makeEditingProfileViewModel(profile: Profile) -> EditingProfileViewModel {
        EditingProfileViewModel(profile: profile, servicesAssembly: self)
    }
    
    func makeStatisticsViewModel() -> StatisticsViewModel {
        StatisticsViewModel(servicesAssembly: self)
    }
    
    func makeUserCardViewModel() -> UserCardViewModel {
        UserCardViewModel(servicesAssembly: self)
    }
    
    func makeUserCollectionViewModel() -> UserCollectionViewModel {
        UserCollectionViewModel(servicesAssembly: self)
    }
    
    func makeCatalogViewModel() -> CatalogViewModel {
        CatalogViewModel(servicesAssembly: self)
    }
    
    func makeCollectionDetailViewModel(collection: NFTCollections) -> CollectionDetailViewModel {
        CollectionDetailViewModel(collection: collection, servicesAssembly: self)
    }
    
    func makeCartViewModel() -> CartViewModel {
        CartViewModel(servicesAssembly: self)
    }
    
    func makePaymentMethodViewModel() -> PaymentMethodViewModel {
        PaymentMethodViewModel(servicesAssembly: self)
    }
}
