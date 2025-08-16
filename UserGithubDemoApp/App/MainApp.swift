//
//  MainApp.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//

import SwiftUI
import SwiftData

@main
struct MainApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            UserDetail.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        registerService()
    }

    var body: some Scene {
        WindowGroup {
            UserListView()
        }
        .modelContainer(sharedModelContainer)
    }

    @MainActor
    private func registerService() {
        let remoteDataSource = RemoteDataSource(remoteService: NetworkServiceProvider())
        let localDataSource = LocalDataSource(modelContext: sharedModelContainer.mainContext)
        let userRepository = UserRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource)

        ServiceLocator.shared.register(userRepository as UserRepository)
    }
}
