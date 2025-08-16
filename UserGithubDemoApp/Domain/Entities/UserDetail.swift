//
//  UserDetail.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Foundation
import SwiftData

@Model
class UserDetail: UserProtocol {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var avatar: String
    var githubURL: String
    var blog: String
    var location: String
    var followers: Int
    var following: Int

    init(name: String, avatar: String, githubURL: String, blog: String, location: String, followers: Int, following: Int) {
        self.name = name
        self.avatar = avatar
        self.githubURL = githubURL
        self.blog = blog
        self.location = location
        self.followers = followers
        self.following = following
    }
}