//
//  UserDetailViewModelTest.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import XCTest
@testable import UserGithubDemoApp

final class UserDetailViewModelTest: XCTestCase {

    func testLoadUserDetailSuccess() {
        var mockRepository = MockUserRepository()
        mockRepository.successCase = true
        let useCase = GetUserDetailUseCase(repository: mockRepository)
        let viewModel = UserDetailViewModel(name: "user", useCase: useCase)

        XCTAssertFalse(viewModel.isShowError, "the error should be false")
        XCTAssertNotNil(viewModel.user, "user should not be nil")
        XCTAssertEqual(viewModel.user?.name, "user", "user's name should be user")
        XCTAssertNotEqual(viewModel.followerCount, "", "the followers count should be not empty")
        XCTAssertNotEqual(viewModel.followingCount, "", "the following count should be not empty")
    }

    func testLoadUserDetailFail() {
        var mockRepository = MockUserRepository()
        mockRepository.successCase = false
        let useCase = GetUserDetailUseCase(repository: mockRepository)
        let viewModel = UserDetailViewModel(name: "user", useCase: useCase)

        viewModel.openBlog()

        XCTAssertTrue(viewModel.isShowError, "should be show the error")
        XCTAssertNil(viewModel.user, "user should be nil")
        XCTAssertEqual(viewModel.followerCount, "", "the followers count should be empty")
        XCTAssertEqual(viewModel.followingCount, "", "the following count should be empty")
        XCTAssertNil(viewModel.user?.blog, "user cannot open blog")
    }

    func testUserHasMoreThan100FollowCount() {
        var mockRepository = MockUserRepository()
        mockRepository.successCase = true
        let useCase = GetUserDetailUseCase(repository: mockRepository)
        let viewModel = UserDetailViewModel(name: "user", useCase: useCase)

        let mockUser = UserDetail(name: "user",
                                  avatar: "avatar",
                                  githubURL: "githubURL",
                                  blog: "blog",
                                  location: "location",
                                  followers: 200,
                                  following: 200)
        viewModel.user = mockUser

        XCTAssertEqual(viewModel.followerCount, "100+", "the followers count should be 100+")
        XCTAssertEqual(viewModel.followingCount, "100+", "the following count should be 100+")
    }

    func testUserCanOpenBlog() {
        var mockRepository = MockUserRepository()
        mockRepository.successCase = true
        let useCase = GetUserDetailUseCase(repository: mockRepository)
        let viewModel = UserDetailViewModel(name: "user", useCase: useCase)

        let expectedBlogURL = URL(string: "blog")

        viewModel.openBlog()

        XCTAssertEqual(viewModel.user?.blog, expectedBlogURL?.absoluteString, "user can open blog")
    }
}
