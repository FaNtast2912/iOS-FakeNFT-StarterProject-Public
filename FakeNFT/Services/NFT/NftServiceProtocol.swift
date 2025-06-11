import Foundation

protocol NftServiceProtocol: ServiceProtocol {
    func loadNft(id: String) async throws -> Nft
    func loadNfts(ids: [String]) async throws -> [Nft]
}
