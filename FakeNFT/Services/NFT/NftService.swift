import Foundation

protocol NftService {
    func loadNft(id: String) async throws -> Nft
}
