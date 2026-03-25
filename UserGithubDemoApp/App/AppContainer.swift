//
//  AppContainer.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//

import Foundation
import SwiftData

/// Central place for building dependencies (Repository + UseCases).
/// Replaces the old `ServiceLocator` approach.
struct AppContainer {
    private let userRepository: UserRepository

    init(modelContext: ModelContext) {
        let remoteDataSource = RemoteDataSource(remoteService: NetworkServiceProvider())
        let localDataSource = LocalDataSource(modelContext: modelContext)
        self.userRepository = UserRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }

    func makeUserListViewModel() -> UserListViewModel {
        let fetchUseCase = GetListUserUseCase(repository: userRepository)
        let deleteUseCase = DeleteLocalUseCase(repository: userRepository)
        return UserListViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUseCase)
    }

    func makeUserDetailViewModel(name: String) -> UserDetailViewModel {
        let useCase = GetUserDetailUseCase(repository: userRepository)
        return UserDetailViewModel(name: name, useCase: useCase)
    }
}

