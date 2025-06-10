//
//  DefaultNetworkClient.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import Foundation

/// Реализация сетевого клиента по умолчанию
struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    // MARK: - Реализация с использованием async/await
    
    func send(request: NetworkRequest) async throws -> Data {
        guard let urlRequest = try create(request: request) else {
            throw NetworkClientError.invalidEndpoint
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkClientError.invalidResponse
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkClientError.httpStatusCode(httpResponse.statusCode)
            }
            
            return data
        } catch let error as NetworkClientError {
            throw error
        } catch {
            throw NetworkClientError.urlRequestError(error)
        }
    }
    
    func send<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> T {
        let data = try await send(request: request)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkClientError.parsingError
        }
    }
    
    // MARK: - Устаревшая реализация с completion handlers
    
    @discardableResult
    func send(request: NetworkRequest,
              completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        let wrappedResponse: (Result<Data, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }
        
        guard let urlRequest = try? create(request: request) else {
            wrappedResponse(.failure(NetworkClientError.invalidEndpoint))
            return nil
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                wrappedResponse(.failure(NetworkClientError.urlRequestError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                wrappedResponse(.failure(NetworkClientError.invalidResponse))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                wrappedResponse(.failure(NetworkClientError.httpStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                wrappedResponse(.failure(NetworkClientError.invalidResponse))
                return
            }
            
            wrappedResponse(.success(data))
        }
        
        task.resume()
        return DefaultNetworkTask(dataTask: task)
    }
    
    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            completionQueue: DispatchQueue,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        return send(request: request, completionQueue: completionQueue) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try self.decoder.decode(T.self, from: data)
                    onResponse(.success(decoded))
                } catch {
#if DEBUG
                    print("NetworkClient decoding error: \(error)")
#endif
                    onResponse(.failure(NetworkClientError.parsingError))
                }
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    
    private func create(request: NetworkRequest) throws -> URLRequest? {
        guard let endpoint = request.endpoint else {
            throw NetworkClientError.invalidEndpoint
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        if let dto = request.dto {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            switch request.httpMethod {
            case .get, .delete:
                try appendQueryParameters(to: &urlRequest, from: dto, baseURL: endpoint)
                
            case .post, .put:
                try appendQueryParameters(to: &urlRequest, from: dto, baseURL: endpoint)
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
        }
        
        return urlRequest
    }
    
    private func appendQueryParameters(to urlRequest: inout URLRequest,
                                       from dto: Dto,
                                       baseURL: URL) throws {
        let dtoDictionary = dto.asDictionary()
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        let queryItems = dtoDictionary.compactMap { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
            urlRequest.url = urlComponents?.url
        }
    }
    
    private func appendJSONBody(to urlRequest: inout URLRequest, from dto: Dto) throws {
        do {
            let dtoDictionary = dto.asDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: dtoDictionary, options: [])
            urlRequest.httpBody = jsonData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        } catch {
            throw NetworkClientError.parsingError
        }
    }
}
