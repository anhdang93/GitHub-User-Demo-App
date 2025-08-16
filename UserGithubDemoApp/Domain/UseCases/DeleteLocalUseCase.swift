//
//  DeleteLocalUseCase.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine

class DeleteLocalUseCase: UseCaseNoRequest {
    typealias Response = Void

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<Void, Error> {
        return repository.removeAllCachedUser()
    }
}