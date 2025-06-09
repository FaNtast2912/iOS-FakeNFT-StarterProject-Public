import Foundation

protocol NftService {
    func loadNft(id: String) async throws -> Nft
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    enum NftServiceError: Error {
        case getNftError
    }

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadNft(id: String) async throws -> Nft {
        let request = NFTRequest(id: id)
        do {
            return try await networkClient.send(request: request, type: Nft.self)
        } catch {
            throw NftServiceError.getNftError
        }
    }
    
}
