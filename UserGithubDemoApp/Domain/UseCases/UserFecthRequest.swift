//
//  UserFecthRequest.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation

struct UserFecthRequest {
    let page: Int
    let itemPerPage: Int

    init(page: Int, itemPerPage: Int = 20) {
        self.page = page
        self.itemPerPage = itemPerPage
    }
}

class GetListUserUseCase: UseCase {
    typealias Request = UserFecthRequest
    typealias Response = [User]

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(_ request: UserFecthRequest) -> AnyPublisher<[User], any Error> {
        return repository.fetchUsers(page: request.page, itemPerPage: request.itemPerPage)
    }
}