import Foundation

final class ServicesAssembly: ObservableObject {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
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
