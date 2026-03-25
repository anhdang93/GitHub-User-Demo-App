//
//  UsersTabView.swift
//  UserGithubDemoApp
//

import SwiftUI

/// Tab view that hosts the Users navigation flow.
struct UsersTabView: View {
    let container: AppContainer

    @StateObject private var coordinator: UserFlowCoordinator

    init(container: AppContainer) {
        self.container = container
        _coordinator = StateObject(wrappedValue: UserFlowCoordinator(container: container))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.destination(for: .userList)
        }
        .navigationDestination(for: UserFlowRoute.self) { route in
            coordinator.destination(for: route)
        }
    }
}

