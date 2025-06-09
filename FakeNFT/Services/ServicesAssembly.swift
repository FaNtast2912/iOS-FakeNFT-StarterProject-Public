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
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }
    
    var userLikesService: UserLikesService {
        UserLikesServiceImpl(networkClient: networkClient)
    }

    var cartNetworkService: CartNetworkService {
        DefaultCartNetworkService(networkClient: networkClient)
    }
    
    var likesManager: LikesManager {
        return _likesManager
    }
    
    var cartManager: CartManager {
        return _cartManager
    }
    
    var userService: UserService {
        UserServiceImpl(
            networkClient: networkClient
        )
    }
    var userByIdService: UserByIdService {
        UserByIdServiceImpl(
            networkClient: networkClient
        )
    }
}
