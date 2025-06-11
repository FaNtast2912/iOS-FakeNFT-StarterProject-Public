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
    /// Отправляет сетевой запрос и возвращает сырые данные
    /// - Parameters:
    ///   - request: Сетевой запрос для отправки
    ///   - queue: Очередь для выполнения completion handler
    /// - Returns: Сетевая задача, которую можно использовать для отмены запроса
    @available(*, deprecated, message: "Используйте версию с async/await")
    @discardableResult
    func send(request: NetworkRequest,
              completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask?
    
    /// Отправляет сетевой запрос и декодирует ответ в указанный тип
    /// - Parameters:
    ///   - request: Сетевой запрос для отправки
    ///   - type: Тип для декодирования ответа
    ///   - queue: Очередь для выполнения completion handler
    /// - Returns: Сетевая задача, которую можно использовать для отмены запроса
    @available(*, deprecated, message: "Используйте версию с async/await")
    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            completionQueue: DispatchQueue,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask?
    
    /// Отправляет сетевой запрос и возвращает сырые данные
    /// - Parameter request: Сетевой запрос для отправки
    /// - Returns: Данные ответа
    /// - Throws: NetworkClientError если запрос завершился с ошибкой
    func send(request: NetworkRequest) async throws -> Data
    
    /// Отправляет сетевой запрос и декодирует ответ в указанный тип
    /// - Parameters:
    ///   - request: Сетевой запрос для отправки
    ///   - type: Тип для декодирования ответа
    /// - Returns: Декодированный ответ
    /// - Throws: NetworkClientError если запрос завершился с ошибкой
    func send<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> T
}

extension NetworkClient {
    @available(*, deprecated, message: "Используйте версию с async/await")
    @discardableResult
    func send(request: NetworkRequest,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        send(request: request, completionQueue: .main, onResponse: onResponse)
    }
    
    @available(*, deprecated, message: "Используйте версию с async/await")
    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
    }
    
    // MARK: - Новые методы с async/await
    
    /// Отправляет сетевой запрос и возвращает сырые данные
    /// - Parameter request: Сетевой запрос для отправки
    /// - Returns: Данные ответа
    /// - Throws: NetworkClientError если запрос завершился с ошибкой
    func send(_ request: NetworkRequest) async throws -> Data {
        try await send(request: request)
    }
    
    /// Отправляет сетевой запрос и декодирует ответ в указанный тип
    /// - Parameters:
    ///   - request: Сетевой запрос для отправки
    ///   - type: Тип для декодирования ответа
    /// - Returns: Декодированный ответ
    /// - Throws: NetworkClientError если запрос завершился с ошибкой
    func send<T: Decodable>(_ request: NetworkRequest, as type: T.Type) async throws -> T {
        try await send(request: request, type: type)
    }
    
    /// Отправляет сетевой запрос и декодирует ответ в указанный тип
    /// - Parameter request: Сетевой запрос для отправки
    /// - Returns: Декодированный ответ
    /// - Throws: NetworkClientError если запрос завершился с ошибкой
    func send<T: Decodable>(_ request: NetworkRequest) async throws -> T {
        try await send(request: request, type: T.self)
    }
}
