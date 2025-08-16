//
//  MockError.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation
@testable import UserGithubDemoApp

enum MockError: Error {
    case fail
}

struct MockUserRepository: UserRepository {
    var successCase: Bool = false

    func fetchUsers(page: Int, itemPerPage: Int) -> AnyPublisher<[User], any Error> {
        guard successCase else {
            return Fail(error: MockError.fail)
                .eraseToAnyPublisher()
        }
        let users = [User(name: "user", avatar: "avatar", githubURL: "githubURL")]
        return Just(users)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchUserDetail(_ name: String) -> AnyPublisher<UserDetail, Error> {
        guard successCase else {
            return Fail(error: MockError.fail)
                .eraseToAnyPublisher()
        }
        let userDetail = UserDetail(name: "user",
                                    avatar: "avatar",
                                    githubURL: "githubURL",
                                    blog: "blog",
                                    location: "location",
                                    followers: 100,
                                    following: 100)
        return Just(userDetail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func removeAllCachedUser() -> AnyPublisher<Void, Error> {
        guard successCase else {
            return Fail(error: MockError.fail)
                .eraseToAnyPublisher()
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
