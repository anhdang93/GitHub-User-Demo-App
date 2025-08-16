//
//  TestError.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
@testable import UserGithubDemoApp

enum TestError: Error {
    case mockError
}

final class MockRemoteDataSource: RemoteDataSource {
    var usersResult: Result<[User], Error>?
    var userDetailResult: Result<UserDetail, Error>?
    var fetchUserCalled = false
    var fetchUserDetailCalled = false
    var lastFetchUserPage: Int?
    var lastFetchUserItemPerPage: Int?
    var lastFetchUserDetailName: String?

    override func fetchUser(page: Int, itemPerPage: Int) -> AnyPublisher<[User], Error> {
        fetchUserCalled = true
        lastFetchUserPage = page
        lastFetchUserItemPerPage = itemPerPage

        if let result = usersResult {
            return result.publisher
                .eraseToAnyPublisher()
        }
        return Fail(error: TestError.mockError)
            .eraseToAnyPublisher()
    }

    override func fetchUserDetail(_ name: String) -> AnyPublisher<UserDetail, Error> {
        fetchUserDetailCalled = true
        lastFetchUserDetailName = name

        if let result = userDetailResult {
            return result.publisher
                .eraseToAnyPublisher()
        }
        return Fail(error: TestError.mockError)
            .eraseToAnyPublisher()
    }
}
