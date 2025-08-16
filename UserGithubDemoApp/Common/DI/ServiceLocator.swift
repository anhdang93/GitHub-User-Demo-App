//
//  ServiceLocator.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Foundation

final class ServiceLocator {
    static let shared = ServiceLocator()

    private var services: [String: Any] = [:]

    private init() {}

    /// Registers a service of a given type to the service locator.
    /// - Parameter service: The service instance to be registered.
    /// - Note: The service's type is used as the key for retrieval later.
    func register<T>(_ service: T) {
        let key = String(describing: T.self)
        services[key] = service
    }

    /// Resolves and retrieves a service of a given type from the service locator.
    /// - Returns: The service instance of the requested type.
    /// - Throws: A runtime error if the requested service type is not found.
    func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let service = services[key] as? T else {
            fatalError("There is no service")
        }
        return service
    }
}