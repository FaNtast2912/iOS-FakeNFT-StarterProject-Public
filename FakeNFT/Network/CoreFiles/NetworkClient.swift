import Foundation

/// Ошибки, которые могут возникнуть при работе с сетевым клиентом
enum NetworkClientError: LocalizedError {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
    case invalidEndpoint
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .httpStatusCode(let code):
            return "Ошибка HTTP с кодом: \(code)"
        case .urlRequestError(let error):
            return "Ошибка URL запроса: \(error.localizedDescription)"
        case .urlSessionError:
            return "Произошла ошибка URL сессии"
        case .parsingError:
            return "Не удалось распарсить данные ответа"
        case .invalidEndpoint:
            return "Некорректный URL эндпоинта"
        case .invalidResponse:
            return "Некорректный ответ от сервера"
        }
    }
}

/// Протокол для работы с сетевыми запросами
protocol NetworkClient {
    func send<T: Codable>(_ request: NetworkRequest, as type: T.Type) async throws -> T
}
