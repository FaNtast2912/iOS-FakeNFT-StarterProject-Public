import Foundation

/// Запрос для получения деталей конкретного NFT
struct NFTRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + RequestConstants.nft + "/\(id)")
    }
    
    var httpMethod: HttpMethod {
        .get
    }
    
    var dto: Dto? {
        nil
    }
}
