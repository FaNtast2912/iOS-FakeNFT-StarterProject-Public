import Foundation

@MainActor
class ServicesAssembly: ObservableObject {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    // Lazy-инициализация менеджеров
    private lazy var _likesManager = LikesManager(userLikesService: userLikesService)
    private lazy var _cartManager = CartManager(
        cartNetworkService: cartNetworkService,
        nftService: nftService
    )
    
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
    @MainActor func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(servicesAssembly: self)
    }
    
    @MainActor func makeMyNFTViewModel() -> MyNFTViewModel {
        MyNFTViewModel(servicesAssembly: self)
    }
    
    @MainActor func makeMyFavoriteNFTViewModel() -> MyFavoriteNFTViewModel {
        MyFavoriteNFTViewModel(servicesAssembly: self)
    }
    
    @MainActor func makeEditingProfileViewModel(profile: Profile) -> EditingProfileViewModel {
        EditingProfileViewModel(profile: profile, servicesAssembly: self)
    }
    
    @MainActor func makeStatisticsViewModel() -> StatisticsViewModel {
        StatisticsViewModel(servicesAssembly: self)
    }
    
    @MainActor func makeUserCardViewModel() -> UserCardViewModel {
        UserCardViewModel(servicesAssembly: self)
    }
    
    @MainActor func makeUserCollectionViewModel() -> UserCollectionViewModel {
        UserCollectionViewModel(servicesAssembly: self)
    }
    
    @MainActor func makeCatalogViewModel() -> CatalogViewModel {
        CatalogViewModel(servicesAssembly: self)
    }
    
    @MainActor func makeCollectionDetailViewModel(collection: NFTCollections) -> CollectionDetailViewModel {
        CollectionDetailViewModel(collection: collection, servicesAssembly: self)
    }
    
    @MainActor func makePaymentMethodViewModel() -> PaymentMethodViewModel {
        PaymentMethodViewModel(servicesAssembly: self)
    }
    
    @MainActor func makeCartViewModel() -> CartViewModel {
        CartViewModel(servicesAssembly: self)
    }
}
