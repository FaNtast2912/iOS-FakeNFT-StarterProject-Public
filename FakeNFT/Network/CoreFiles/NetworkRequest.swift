import Foundation

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Dto? { get }
    var headers: [String: String]? { get }
}

extension NetworkRequest {
    var headers: [String: String]? {
        [
            "X-Practicum-Mobile-Token": RequestConstants.token,
            "Accept": "application/json"
        ]
    }
}

