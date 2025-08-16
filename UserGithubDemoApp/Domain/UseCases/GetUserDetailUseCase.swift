//
//  GetUserDetailUseCase.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation

class GetUserDetailUseCase: UseCase {
    typealias Request = String
    typealias Response = UserDetail

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(_ request: String) -> AnyPublisher<UserDetail, any Error> {
        return repository.fetchUserDetail(request)
    }
}