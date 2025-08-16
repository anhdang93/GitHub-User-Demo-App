//
//  UserRepositoryImpl.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation

struct UserRepositoryImpl: UserRepository {
    private let remoteDataSource: RemoteDataSource
    private let localDataSource: LocalDataSource

    init(remoteDataSource: RemoteDataSource, localDataSource: LocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    /// Fetches a list of users based on pagination parameters.
    /// - Parameters:
    ///   - page: The page index for pagination.
    ///   - itemPerPage: The number of items per page.
    /// - Returns: A publisher emitting the list of users or an error.
    func fetchUsers(page: Int, itemPerPage: Int) -> AnyPublisher<[User], Error> {
        // fetch local data first
        // if there is no data --> fetch data from remote service
        // when finish load from remote service --> storage in local data
        return localDataSource.fetchUsers(page: page, itemPerPage: itemPerPage)
            .flatMap { localUsers -> AnyPublisher<[User], Error> in
                if localUsers.isEmpty {
                    return remoteDataSource
                        .fetchUser(page: page, itemPerPage: itemPerPage)
                        .map {
                            self.localDataSource.saveUsers(users: $0)
                            return $0
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Just(localUsers)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    /// Fetches detailed information about a specific user.
    /// - Parameter name: The name of the user to fetch details for.
    /// - Returns: A publisher emitting user details or an error.
    func fetchUserDetail(_ name: String) -> AnyPublisher<UserDetail, Error> {
        // fetch local data first
        // if there is no data --> fetch data from remote service
        // when finish load from remote service --> storage in local data
        return localDataSource.fetchUserDetails(name)
            .flatMap { userDetail -> AnyPublisher<UserDetail, Error> in
                if let userDetail = userDetail {
                    return Just(userDetail)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return remoteDataSource.fetchUserDetail(name)
                        .map {
                            localDataSource.saveUserDetails(userDetail: $0)
                            return $0
                        }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    func removeAllCachedUser() -> AnyPublisher<Void, Error> {
        return localDataSource.removeAllCachedData()
    }
}