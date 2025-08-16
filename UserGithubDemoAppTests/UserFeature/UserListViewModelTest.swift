//
//  UserListViewModelTest.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import XCTest
@testable import UserGithubDemoApp

final class UserListViewModelTest: XCTestCase {

    func testLoadUserListSuccess() {
        let fetchUseCase = MockGetListUserUseCase(repository: MockUserRepository())
        let deleteUsecase = MockDeleteLocalUseCase(repository: MockUserRepository())
        let viewModel = UserListViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUsecase)

        XCTAssertFalse(viewModel.isShowError, "the error should be false")
        XCTAssertNotNil(viewModel.users, "user should not be nil")
    }

    func testLoadUserListFail() {
        var mockRepository = MockUserRepository()
        mockRepository.successCase = false
        let fetchUseCase = GetListUserUseCase(repository: mockRepository)
        let deleteUsecase = DeleteLocalUseCase(repository: mockRepository)
        let viewModel = UserListViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUsecase)

        XCTAssertTrue(viewModel.users.isEmpty, "user should not be empty")
    }

    func testLoadUserCanCallLoadMore() {
        var mockRepository = MockUserRepository()
        mockRepository.successCase = true
        let fetchUseCase = MockGetListUserUseCase(repository: mockRepository)
        fetchUseCase.result = .success([User(name: "user", avatar: "avatar", githubURL: "github")])
        let deleteUsecase = MockDeleteLocalUseCase(repository: mockRepository)
        let viewModel = UserListViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUsecase)

        let users = (1...10).map { User(name: "user_\($0)", avatar: "avatar_\($0)", githubURL: "url_\($0)") }
        viewModel.users = users
        let user = users[users.count - 5]

        viewModel.checkForMore(user)

        let expectation = XCTestExpectation(description: "Wait for delay")

        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { // 2-second delay
            expectation.fulfill() // Signal that the task is complete
        }

        // Wait for the expectation to be fulfilled with a timeout
        wait(for: [expectation], timeout: 3.0) // 3-second timeout

        XCTAssertTrue(viewModel.users.count != 10, "user should be different with 10 users")
    }

    func testRefreshUsers() {
        let mockRepository = MockUserRepository()
        let fetchUseCase = MockGetListUserUseCase(repository: mockRepository)
        fetchUseCase.result = .success([User(name: "user", avatar: "avatar", githubURL: "github")])
        let deleteUsecase = MockDeleteLocalUseCase(repository: mockRepository)
        deleteUsecase.result = .success(())
        let viewModel = UserListViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUsecase)

        let users = (1...10).map { User(name: "user_\($0)", avatar: "avatar_\($0)", githubURL: "url_\($0)") }
        viewModel.users = users

        viewModel.refresh()

        let expectation = XCTestExpectation(description: "Wait for delay")

        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { // 2-second delay
            expectation.fulfill() // Signal that the task is complete
        }

        // Wait for the expectation to be fulfilled with a timeout
        wait(for: [expectation], timeout: 3.0) // 3-second timeout

        XCTAssertTrue(viewModel.users.count == 1, "user should be equal 1")
    }

    func testDeleteLocalFail() {
        let mockRepository = MockUserRepository()
        let fetchUseCase = MockGetListUserUseCase(repository: mockRepository)
        fetchUseCase.result = .success([User(name: "user", avatar: "avatar", githubURL: "github")])
        let deleteUsecase = MockDeleteLocalUseCase(repository: mockRepository)
        deleteUsecase.result = .failure(MockError.fail)
        let viewModel = UserListViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUsecase)

        viewModel.refresh()
        XCTAssertTrue(viewModel.isShowError, "show error should be true")
    }
}
