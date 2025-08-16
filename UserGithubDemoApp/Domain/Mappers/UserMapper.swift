//
//  UserMapper.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Foundation

enum UserMapper {
    static func mapUserFromDTO(_ userDTO: UserDTO) -> User {
        return User(name: userDTO.name,
                    avatar: userDTO.avatar,
                    githubURL: userDTO.githubURL)
    }

    static func mapUserDetailFromDTO(_ userDetailDTO: UserDetailDTO) -> UserDetail {
        return UserDetail(name: userDetailDTO.name,
                          avatar: userDetailDTO.avatar,
                          githubURL: userDetailDTO.githubURL,
                          blog: userDetailDTO.blog,
                          location: userDetailDTO.location,
                          followers: userDetailDTO.followers,
                          following: userDetailDTO.following)
    }
}