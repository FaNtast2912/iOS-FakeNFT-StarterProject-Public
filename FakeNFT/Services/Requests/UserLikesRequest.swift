import Foundation

struct UserLikesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.profile)")
    }
    
    var httpMethod: HttpMethod = .get
    var dto: Dto?
    
}
