//
//  NetworkDispatcher.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import Foundation
import PromiseKit

protocol NetworkDispatcher {

    static var network: Network { get set }
    static func execute<R: Request, T: Codable>(request: R, for type: T.Type) -> Promise<T?>
}

class BaseNetworkDispatcher: NetworkDispatcher {

    static var network: Network = BaseNetwork()
    static private let session = URLSession(configuration: URLSessionConfiguration.default)

    static func execute<R: Request, T: Codable>(request: R, for type: T.Type) -> Promise<T?> {

        let urlRequest: URLRequest
        do {
            urlRequest = try buildRequest(request: request)
        } catch {
            return Promise(error: error)
        }

        return Promise<T?> { seal in
            firstly {
                session.dataTask(.promise, with: urlRequest).validate()
            }.compactMap {
                let response = try JSONDecoder().decode(type, from: $0.data)
                seal.fulfill(response)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}

private extension BaseNetworkDispatcher {

    static func buildRequest<R: Request>(request: R) throws -> URLRequest {

        let urlString = network.domain + request.path
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        var urlRequest: URLRequest = URLRequest(url: url)

        if request.httpMethod != .get, let body = request.body, let data = body.toData {
            urlRequest.httpBody = data
        }

        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.timeoutInterval = network.timeout
        network.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        return urlRequest
    }
}
