//
//  NetworkServiceImpl.swift
//  NetworkingInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

import NetworkingInterface

final class NetworkServiceImpl: NetworkService {
    
    private enum Const {
        
        static let timeout: TimeInterval = 30.0
    }
    
    private let session: URLSession
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder: JSONDecoder = .init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
        session.configuration.requestCachePolicy = .useProtocolCachePolicy
    }
    
    func request<T: Decodable>(target: TargetType) async throws -> T {
        let data = try await performRequest(target: target)
        return try jsonDecoder.decode(T.self, from: data)
    }
}

private extension NetworkServiceImpl {
    
    func performRequest(target: TargetType) async throws -> Data {
        let request: URLRequest = try buildRequest(from: target)
        do {
            let data = try await createDataTask(with: request)
            return data
        } catch {
            guard
                case let NetworkError.statusCode(response) = error,
                let httpResponse = response as? HTTPURLResponse
            else {
                throw error
            }
            
            throw target.errorMap[httpResponse.statusCode] ?? error
        }
    }
    
    func createDataTask(with request: URLRequest) async throws -> Data {
        do {
            let (data, response): (Data, URLResponse)
            
            if #available(iOS 15.0, *) {
                (data, response) = try await session.data(for: request, delegate: nil)
            } else {
                (data, response) = try await session.data(for: request)
            }
            
            guard 
                let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode
            else {
                throw NetworkError.statusCode(response)
            }
            
            return data
            
        } catch {
            throw NetworkError.underlying(error)
        }
    }
}

private extension NetworkServiceImpl {
    
    func buildRequest(from target: TargetType) throws -> URLRequest {
        let urlComponents = try configureURLComponents(from: target)
        let request = try configureURLRequest(from: urlComponents, with: target)
        return request
    }
    
    func configureURLComponents(from target: TargetType) throws -> URLComponents {
        guard let url = target.baseURL?.appendingPathComponent(target.path),
              var urlComponents = URLComponents(string: url.absoluteString) else {
            throw NetworkError.invalidURL
        }
        
        if let parameters = target.parameters,
           /// .get, .head, .delete
           [HTTPMethod.get].contains(target.method) {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        }
        
        return urlComponents
    }
    
    func configureURLRequest(from urlComponents: URLComponents, with target: TargetType) throws -> URLRequest {
        guard let finalUrl = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(
            url: finalUrl,
            cachePolicy: .reloadRevalidatingCacheData,
            timeoutInterval: Const.timeout
        )
        
        request.httpMethod = target.method.rawValue
        
        if let headers = target.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}
