//
//  MockGetListUserUseCase.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
@testable import UserGithubDemoApp

final class MockGetListUserUseCase: GetListUserUseCase {
    var result: Result<[User], Error>?
    var isExecuteCalled = false

    override func execute(_ request: UserFecthRequest) -> AnyPublisher<[User], Error> {
        isExecuteCalled = true
        return Future { promise in
            if let result = self.result {
                promise(result)
            }
        }.eraseToAnyPublisher()
    }
}
