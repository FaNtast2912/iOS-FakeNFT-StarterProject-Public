import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Dto? { get }
    var headers: [String: String]? { get } // Добавляем поддержку headers
}

protocol Dto {
    func asDictionary() -> [String: String]
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var headers: [String: String]? { nil } // Делаем headers опциональным по умолчанию
}

/// Запрос для получения списка коллекций
struct CatalogRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + RequestConstants.collections)
    }
    
    var httpMethod: HttpMethod {
        .get
    }
    
    var dto: Dto? {
        nil
    }
}
