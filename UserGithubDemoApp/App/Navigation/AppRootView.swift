//
//  AppRootView.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//

import SwiftData
import SwiftUI

struct AppRootView: View {
    let modelContainer: ModelContainer

    private let container: AppContainer
    @State private var selectedTab: AppTab = .users

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.container = AppContainer(modelContext: modelContainer.mainContext)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            UsersTabView(container: container)
                .tabItem {
                    Label("Users", systemImage: "person.2")
                }
                .tag(AppTab.users)
        }
    }
}

