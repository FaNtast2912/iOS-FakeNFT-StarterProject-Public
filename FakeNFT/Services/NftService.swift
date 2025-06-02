import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftService {
//    func loadNft(id: String, completion: @escaping NftCompletion)
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

//    func loadNft(id: String, completion: @escaping NftCompletion) {
//        if let nft = storage.getNft(with: id) {
//            completion(.success(nft))
//            return
//        }
//
//        let request = NFTRequest(id: id)
//        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
//            switch result {
//            case .success(let nft):
//                storage?.saveNft(nft)
//                completion(.success(nft))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func loadNft(id: String) async throws -> Nft {
        let request = NFTRequest(id: id)
        do {
            return try await networkClient.send(request: request, type: Nft.self)
        } catch {
            throw NftServiceError.getNftError
        }
    }
    
    
}
