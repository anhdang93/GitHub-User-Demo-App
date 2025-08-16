//
//  MockLocalService.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Foundation
import SwiftData
@testable import UserGithubDemoApp

struct MockLocalService {
    static var shared = MockLocalService()

    private init() { }

    private var sharedModelContainer: ModelContainer = {
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

    @MainActor
    var modelContext: ModelContext {
        sharedModelContainer.mainContext
    }
}
