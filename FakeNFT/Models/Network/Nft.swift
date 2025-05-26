import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let createdAt: String
    let images: [URL]
    let raiting: Int
    let description: String
    let price: Float
    let author: String
}
