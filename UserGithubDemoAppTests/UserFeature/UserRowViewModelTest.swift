//
//  UserRowViewModelTest.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import XCTest
@testable import UserGithubDemoApp

final class UserRowViewModelTest: XCTestCase {

    var viewModel: UserRowViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.setUpWithError()
    }

    func testDisplayListUser() {
        let user = User(name: "user1", avatar: "avatar1", githubURL: "githublink")
        viewModel = UserRowViewModel(user: user)

        let expectedAvatar = URL(string: "avatar1")
        let expectedGithubLink = URL(string: "githublink")

        XCTAssertEqual(viewModel.type, .list, "Type should be list type")
        XCTAssertEqual(viewModel.name, "user1", "Name should be user1")
        XCTAssertEqual(viewModel.location, "", "Location should be empty")
        XCTAssertEqual(viewModel.avatarURL, expectedAvatar, "avatar url should not be nil")
        XCTAssertEqual(viewModel.gitHubLink, expectedGithubLink, "gitHubLink url should not be nil")
    }

    func testDisplayUserDetail() {
        let user = UserDetail(name: "user1",
                              avatar: "avatar",
                              githubURL: "githublink",
                              blog: "blog",
                              location: "location",
                              followers: 100,
                              following: 100)
        viewModel = UserRowViewModel(user: user)

        let expectedAvatar = URL(string: "avatar")
        let expectedGithubLink = URL(string: "githublink")

        XCTAssertEqual(viewModel.type, .detail, "Type should be detail type")
        XCTAssertEqual(viewModel.name, "user1", "Name should be user1")
        XCTAssertEqual(viewModel.location, "location", "Location should be location")
        XCTAssertEqual(viewModel.avatarURL, expectedAvatar, "avatar url should not be nil")
        XCTAssertEqual(viewModel.gitHubLink, expectedGithubLink, "gitHubLink url should not be nil")
    }

    func testCanOpenGithubLink() {
        // Arrange
        let expectedURL = URL(string: "https://github.com/testurl")!
        let user = User(
            name: "testurluser",
            avatar: "",
            githubURL: expectedURL.absoluteString
        )
        let viewModel = UserRowViewModel(user: user)

        // Act
        let urlToOpen = viewModel.gitHubLink

        viewModel.openGitHubLink()

        // Assert
        XCTAssertEqual(urlToOpen, expectedURL, "Can open the git hub link")
    }

    func testCanNotOpenGithubLink() {
        // Arrange
        let user = User(
            name: "nilurluser",
            avatar: "",
            githubURL: ""
        )
        let viewModel = UserRowViewModel(user: user)

        viewModel.openGitHubLink()

        // Assert
        XCTAssertNil(viewModel.gitHubLink, "git hub link should still be nil")
    }
}
