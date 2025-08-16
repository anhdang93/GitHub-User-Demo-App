//
//  LocalDataSource.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation
import SwiftData

class LocalDataSource {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    /// Saves a list of user objects to the local storage.
    /// - Parameter users: An array of `User` objects to be saved.
    func saveUsers(users: [User]) {
        users.forEach {
            modelContext.insert($0)
        }
        try? modelContext.save()
    }

    /// Fetches a list of users from the local storage based on pagination parameters.
    /// - Parameters:
    ///   - page: The page index for pagination.
    ///   - itemPerPage: The number of items per page.
    /// - Returns: A publisher emitting an array of `User` or an error
    func fetchUsers(page: Int, itemPerPage: Int) -> AnyPublisher<[User], Error> {
        do {
            var fetchDescriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.timeStamp, order: .forward)])
            fetchDescriptor.fetchLimit = itemPerPage
            fetchDescriptor.fetchOffset = page * itemPerPage

            let users = try modelContext.fetch(fetchDescriptor)
            return Just(users)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }

    /// Saves user detail data to the local storage.
    /// - Parameter userDetail: A `UserDetail` object to be saved.
    func saveUserDetails(userDetail: UserDetail) {
        modelContext.insert(userDetail)
        try? modelContext.save()
    }

    /// Fetches user detail data from the local storage for a specific user.
    /// - Parameter name: The name of the user to fetch details for.
    /// - Returns: A publisher emitting an optional `UserDetail` or an error.
    func fetchUserDetails(_ name: String) -> AnyPublisher<UserDetail?, Error> {
        do {
            let fetchDescriptor = FetchDescriptor<UserDetail>(predicate: #Predicate {
                $0.name == name
            })

            let userDetail = try modelContext.fetch(fetchDescriptor).first
            return Just(userDetail)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }

    // Removes all cached user and user detail data from the local storage.
    /// - Returns: A publisher that emits completion or an error.
    func removeAllCachedData() -> AnyPublisher<Void, Error> {
        do {
            try modelContext.delete(model: User.self)
            try modelContext.delete(model: UserDetail.self)
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}