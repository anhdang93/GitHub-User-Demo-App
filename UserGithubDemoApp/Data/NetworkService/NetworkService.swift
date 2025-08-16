//
//  NetworkService.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation

protocol NetworkService {
    func fetch<T: Decodable>(_ endPoint: EndPoint) -> AnyPublisher<T, Error>
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndPoint {
    var path: String { get set}
    var method: HTTPMethod { get set }
    var headers: [String: String]? { get set }
    var queryParams: [URLQueryItem]? { get set }
    var bodyParams: [String: Any]? { get set }
}

extension EndPoint {
    var url: URL? {
        var urlComponents = URLComponents(string: Configuration.baseURL + path)
        urlComponents?.queryItems = queryParams
        return urlComponents?.url
    }

    var headerData: [String: String] {
        var mergedHeaders = Configuration.defaultHeaders
        if let headers = headers {
            for (key, value) in headers {
                mergedHeaders[key] = value
            }
        }
        return mergedHeaders
    }

    var bodyData: Data? {
        guard let bodyParams = bodyParams else { return nil }
        return try? JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
    }
}

struct NetworkServiceProvider: NetworkService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Fetches data from the given endpoint and decodes it into the specified type.
    /// - Parameter endPoint: The endpoint to fetch data from.
    /// - Returns: A publisher emitting the decoded object or an error.
    func fetch<T>(_ endPoint: EndPoint) -> AnyPublisher<T, any Error> where T : Decodable {
        guard let url = endPoint.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        endPoint.headerData.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpBody = endPoint.bodyData
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}