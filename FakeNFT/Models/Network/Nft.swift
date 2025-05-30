import Foundation

struct Nft: Codable {
    let id: String
    let name: String
    let createdAt: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: String
}
