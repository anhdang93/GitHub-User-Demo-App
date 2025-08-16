//
//  AssingmentTests.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import XCTest
@testable import UserGithubDemoApp

final class UserRepositoryImplTests: XCTestCase {

    var sut: UserRepositoryImpl!
    var mockRemoteDataSource: MockRemoteDataSource!
    var mockLocalDataSource: MockLocalDataSource!
    var cancellables = Set<AnyCancellable>()

    @MainActor 
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRemoteDataSource = MockRemoteDataSource(remoteService: MockRemoteService())
        mockLocalDataSource = MockLocalDataSource(modelContext: MockLocalService.shared.modelContext)
        sut = UserRepositoryImpl(remoteDataSource: mockRemoteDataSource, localDataSource: mockLocalDataSource)
        cancellables = []
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRemoteDataSource = nil
        mockLocalDataSource = nil
        try super.tearDownWithError()
    }

    func testGetDataFromLocal() throws {
        let expectedUsers = [User(name: "user1", avatar: "url1", githubURL: "githubLink")]
        mockLocalDataSource.usersResult = .success(expectedUsers)
        let expectation = XCTestExpectation(description: "Fetch users completes")
        var receivedUsers: [User]?
        var receivedError: Error?

        // Act
        sut.fetchUsers(page: 0, itemPerPage: 20)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { users in
                receivedUsers = users
            })
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedUsers, expectedUsers, "Should return users from local data source")
        XCTAssertNil(receivedError, "Should not receive an error")
        XCTAssertFalse(mockRemoteDataSource.fetchUserCalled, "Remote data source should not be called")
        XCTAssertFalse(mockLocalDataSource.saveUsersCalled, "Save users should not be called")
    }

    func testGetDataFromRemote() {
        // Arrange
        let remoteUsers = [User(name: "user_remote", avatar: "url_remote", githubURL: "url_remote")]
        mockLocalDataSource.usersResult = .success([]) // Local is empty
        mockRemoteDataSource.usersResult = .success(remoteUsers)
        let expectation = XCTestExpectation(description: "Fetch users completes")
        var receivedUsers: [User]?
        var receivedError: Error?

        // Act
        sut.fetchUsers(page: 0, itemPerPage: 20)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { users in
                receivedUsers = users
            })
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedUsers, remoteUsers, "Should return users from remote data source")
        XCTAssertNil(receivedError, "Should not receive an error")
        XCTAssertTrue(mockRemoteDataSource.fetchUserCalled, "Remote data source should be called")
        XCTAssertEqual(mockRemoteDataSource.lastFetchUserPage, 0)
        XCTAssertEqual(mockRemoteDataSource.lastFetchUserItemPerPage, 20)
        XCTAssertTrue(mockLocalDataSource.saveUsersCalled, "Save users should be called")
        XCTAssertEqual(mockLocalDataSource.savedUsers, remoteUsers, "Should save the remote users locally")
    }

    func testGetDataRemoteError() {
        // Arrange
        mockLocalDataSource.usersResult = .success([])
        mockRemoteDataSource.usersResult = .failure(TestError.mockError)
        let expectation = XCTestExpectation(description: "Fetch users fails")
        var receivedUsers: [User]?
        var receivedError: Error?

        // Act
        sut.fetchUsers(page: 0, itemPerPage: 20)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { users in
                receivedUsers = users
            })
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(receivedUsers, "Should not receive users on failure")
        XCTAssertNotNil(receivedError, "Should receive an error")
        XCTAssertTrue(mockRemoteDataSource.fetchUserCalled, "Remote data source should be called")
        XCTAssertFalse(mockLocalDataSource.saveUsersCalled, "Save users should not be called on remote failure")
        XCTAssert(receivedError is TestError, "Error should be the one from the remote source")
    }

    // MARK: - fetchUserDetail Tests

    func testGetUserDetailFromLocal() {
        // Arrange
        let expectedDetail = UserDetail(name: "user1",
                                        avatar: "test avatar",
                                        githubURL: "githubUrl",
                                        blog: "blog_url",
                                        location: "location",
                                        followers: 100,
                                        following: 50)
        mockLocalDataSource.userDetailResult = .success(expectedDetail)
        let expectation = XCTestExpectation(description: "Fetch user detail completes")
        var receivedDetail: UserDetail?
        var receivedError: Error?

        // Act
        sut.fetchUserDetail("detail_user")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { detail in
                receivedDetail = detail
            })
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedDetail, expectedDetail, "Should return detail from local data source")
        XCTAssertNil(receivedError, "Should not receive an error")
        XCTAssertFalse(mockRemoteDataSource.fetchUserDetailCalled, "Remote data source should not be called")
        XCTAssertFalse(mockLocalDataSource.saveUserDetailsCalled, "Save user detail should not be called")
    }

    func testGetUserDetailFromRemote() {
        // Arrange
        let remoteDetail = UserDetail(name: "user1",
                                      avatar: "test avatar",
                                      githubURL: "githubUrl",
                                      blog: "blog_url",
                                      location: "location",
                                      followers: 100,
                                      following: 50)      
        mockLocalDataSource.userDetailResult = .success(nil) // Local is nil
        mockRemoteDataSource.userDetailResult = .success(remoteDetail)
        let expectation = XCTestExpectation(description: "Fetch user detail completes")
        var receivedDetail: UserDetail?
        var receivedError: Error?

        // Act
        sut.fetchUserDetail("remote_detail")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { detail in
                receivedDetail = detail
            })
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedDetail, remoteDetail, "Should return detail from remote data source")
        XCTAssertNil(receivedError, "Should not receive an error")
        XCTAssertTrue(mockRemoteDataSource.fetchUserDetailCalled, "Remote data source should be called")
        XCTAssertEqual(mockRemoteDataSource.lastFetchUserDetailName, "remote_detail")
        XCTAssertTrue(mockLocalDataSource.saveUserDetailsCalled, "Save user detail should be called")
        XCTAssertEqual(mockLocalDataSource.savedUserDetail, remoteDetail, "Should save the remote detail locally")
    }

    func testGetUserDetailFail() {
        // Arrange
        mockLocalDataSource.userDetailResult = .success(nil) // Local is nil
        mockRemoteDataSource.userDetailResult = .failure(TestError.mockError)
        let expectation = XCTestExpectation(description: "Fetch user detail fails")
        var receivedDetail: UserDetail?
        var receivedError: Error?

        // Act
        sut.fetchUserDetail("fail_user")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { detail in
                receivedDetail = detail
            })
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(receivedDetail, "Should not receive detail on failure")
        XCTAssertNotNil(receivedError, "Should receive an error")
        XCTAssertTrue(mockRemoteDataSource.fetchUserDetailCalled, "Remote data source should be called")
        XCTAssertEqual(mockRemoteDataSource.lastFetchUserDetailName, "fail_user")
        XCTAssertFalse(mockLocalDataSource.saveUserDetailsCalled, "Save user detail should not be called on remote failure")
        XCTAssert(receivedError is TestError, "Error should be the one from the remote source")
    }

    // MARK: - removeAllCachedUser Tests

    func testRemoveLocalStorage() {
        // Arrange
        mockLocalDataSource.removeAllResult = .success(())
        let expectation = XCTestExpectation(description: "Remove all cached users completes")
        var receivedError: Error?
        var completed = false

        // Act
        sut.removeAllCachedUser()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                } else {
                    completed = true
                }
                expectation.fulfill()
            }, receiveValue: { _ in }) // No value expected
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(completed, "Publisher should complete successfully")
        XCTAssertNil(receivedError, "Should not receive an error")
        XCTAssertTrue(mockLocalDataSource.removeAllCalled, "LocalDataSource removeAllCachedData should be called")
    }

    func testRemoveLocalStorageFail() {
        // Arrange
        mockLocalDataSource.removeAllResult = .failure(TestError.mockError)
        let expectation = XCTestExpectation(description: "Remove all cached users fails")
        var receivedError: Error?
        var completed = false

        // Act
        sut.removeAllCachedUser()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                } else {
                    completed = true // Should not complete successfully
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(completed, "Publisher should not complete successfully")
        XCTAssertNotNil(receivedError, "Should receive an error")
        XCTAssertTrue(mockLocalDataSource.removeAllCalled, "LocalDataSource removeAllCachedData should be called")
        XCTAssert(receivedError is TestError, "Error should be the one from the local source")
    }
}
