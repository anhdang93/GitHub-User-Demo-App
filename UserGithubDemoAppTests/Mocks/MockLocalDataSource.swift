//
//  MockLocalDataSource.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
@testable import UserGithubDemoApp

final class MockLocalDataSource: LocalDataSource {
    var usersResult: Result<[User], Error>?
    var userDetailResult: Result<UserDetail?, Error>?
    var saveUsersCalled = false
    var saveUserDetailsCalled = false
    var removeAllCalled = false
    var removeAllResult: Result<Void, Error>?

    var savedUsers: [User]?
    var savedUserDetail: UserDetail?

    override func fetchUsers(page: Int, itemPerPage: Int) -> AnyPublisher<[User], Error> {
        if let result = usersResult {
            return result.publisher
                .eraseToAnyPublisher()
        }
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    override func fetchUserDetails(_ name: String) -> AnyPublisher<UserDetail?, Error> {
        if let result = userDetailResult {
            return result.publisher
                .eraseToAnyPublisher()
        }
        return Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    override func saveUsers(users: [User]) {
        saveUsersCalled = true
        savedUsers = users
    }

    override func saveUserDetails(userDetail: UserDetail) {
        saveUserDetailsCalled = true
        savedUserDetail = userDetail
    }

    override func removeAllCachedData() -> AnyPublisher<Void, Error> {
        removeAllCalled = true
        if let result = removeAllResult {
            return result.publisher
                .eraseToAnyPublisher()
        }
        // Default: succeed
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
