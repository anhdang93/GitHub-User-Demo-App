//
//  UserRowType.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Foundation
import UIKit

enum UserRowType {
    case list, detail
}

final class UserRowViewModel {
    private let user: any UserProtocol

    var type: UserRowType {
        user is UserDetail ? .detail : .list
    }

    init(user: any UserProtocol) {
        self.user = user
    }

    var avatarURL: URL? {
        URL(string: user.avatar)
    }

    var name: String {
        user.name
    }

    var gitHubLink: URL? {
        return URL(string: user.githubURL)
    }

    var location: String {
        guard let userDetail = user as? UserDetail else { return "" }
        return userDetail.location
    }

    func openGitHubLink() {
        guard let gitHubLink = gitHubLink else { return }
        UIApplication.shared.open(gitHubLink)
    }
}