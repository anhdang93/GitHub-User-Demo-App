//
//  User.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Foundation
import SwiftData

@Model
class User: UserProtocol {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var avatar: String
    var githubURL: String
    var timeStamp: Date = Date()

    init(name: String, avatar: String, githubURL: String) {
        self.name = name
        self.avatar = avatar
        self.githubURL = githubURL
    }
}