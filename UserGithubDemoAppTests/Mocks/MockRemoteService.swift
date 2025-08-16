//
//  MockRemoteService.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
@testable import UserGithubDemoApp

final class MockRemoteService: NetworkService {
    func fetch<T>(_ endPoint: any EndPoint) -> AnyPublisher<T, any Error> where T : Decodable {
        return Just(T.self as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
