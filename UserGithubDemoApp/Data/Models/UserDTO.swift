//
//  UserDTO.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Foundation

struct UserDTO: Decodable {
    let id: Int
    let name: String
    let avatar: String
    let githubURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatar = "avatar_url"
        case githubURL = "html_url"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        self.githubURL = try container.decodeIfPresent(String.self, forKey: .githubURL) ?? ""
    }
}