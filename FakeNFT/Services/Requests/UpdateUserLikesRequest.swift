import Foundation

struct UpdateUserLikesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.profile)")
    }
    
    var httpMethod: HttpMethod = .put
    var dto: Dto?
    
}

struct UserLikesRequestDto: Dto {
    let likes: [String]
    
    private enum LikesKey: String {
        case likes
    }
    
    func asDictionary() -> [String : String] {
        let likes = likes.isEmpty ? "null" : likes.joined(separator: ", ")
        return [ LikesKey.likes.rawValue: likes]
    }
}
