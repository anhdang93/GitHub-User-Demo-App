//
//  PreviewUserRepository.swift
//  UserGithubDemoApp
//
//  Simple repository used only for SwiftUI `#Preview`.
//

import Combine
import Foundation

struct PreviewUserRepository: UserRepository {
    func fetchUsers(page: Int, itemPerPage: Int) -> AnyPublisher<[User], Error> {
        // Provide stable mock data for previews.
        let users = [
            User(
                name: "mojombo",
                avatar: "https://avatars.githubusercontent.com/u/1?v=4",
                githubURL: "https://github.com/mojombo"
            ),
            User(
                name: "defunkt",
                avatar: "https://avatars.githubusercontent.com/u/2?v=4",
                githubURL: "https://github.com/defunkt"
            )
        ]

        return Just(users)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchUserDetail(_ name: String) -> AnyPublisher<UserDetail, Error> {
        let detail = UserDetail(
            name: name,
            avatar: "https://avatars.githubusercontent.com/u/1?v=4",
            githubURL: "https://github.com/\(name)",
            blog: "https://example.com/blog",
            location: "Internet",
            followers: 120,
            following: 80
        )

        return Just(detail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func removeAllCachedUser() -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

