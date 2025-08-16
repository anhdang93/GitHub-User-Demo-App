//
//  UserDetailViewModel.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation
import UIKit

final class UserDetailViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isShowError = false
    @Published var user: UserDetail?

    private let useCase: GetUserDetailUseCase
    private var cancellables = Set<AnyCancellable>()

    init(name: String, useCase: GetUserDetailUseCase) {
        self.useCase = useCase
        fetchUserDetail(name)
    }

    /// Fetches detailed information for a specific user.
    /// - Parameter name: The name of the user whose details are to be fetched.
    private func fetchUserDetail(_ name: String) {
        isLoading.toggle()
        useCase.execute(name)
            .sink { completion in
                self.isLoading = false
                if case .failure(_) = completion {
                    self.isShowError = true
                }
            } receiveValue: { userDetail in
                self.user = userDetail
            }
            .store(in: &cancellables)
    }

    /// Retrieves the follower count of the user in a formatted string.
    /// - Returns: A formatted string representing the follower count. Returns an empty string if user details are unavailable.
    var followerCount: String {
        guard let userDetail = user else {
            return ""
        }
        return userDetail.followers > 100 ? "100+" : "\(userDetail.followers)"
    }

    /// Retrieves the following count of the user in a formatted string.
    /// - Returns: A formatted string representing the following count. Returns an empty string if user details are unavailable.
    var followingCount: String {
        guard let userDetail = user else {
            return ""
        }
        return userDetail.following > 100 ? "100+" : "\(userDetail.following)"
    }

    /// Opens the user's blog in the default browser.
    /// - Note: Does nothing if the blog URL is invalid or unavailable.
    func openBlog() {
        guard let blog = user?.blog,
              let url = URL(string: blog) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
