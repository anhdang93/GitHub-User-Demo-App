//
//  MockDeleteLocalUseCase.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
@testable import UserGithubDemoApp

final class MockDeleteLocalUseCase: DeleteLocalUseCase{
    var result: Result<Void, Error>?

    override func execute() -> AnyPublisher<Void, Error> {
        return Future { promise in
            if let result = self.result {
                promise(result)
            }
        }.eraseToAnyPublisher()
    }
}
