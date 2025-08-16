//
//  UserRepository.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation

protocol UserRepository {
    func fetchUsers(page: Int, itemPerPage: Int) -> AnyPublisher<[User], Error>
    func fetchUserDetail(_ name: String) -> AnyPublisher<UserDetail, Error>
    func removeAllCachedUser() -> AnyPublisher<Void, Error>
}