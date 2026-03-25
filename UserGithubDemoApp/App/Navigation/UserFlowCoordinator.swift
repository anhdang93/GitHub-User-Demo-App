//
//  UserFlowCoordinator.swift
//  UserGithubDemoApp
//

import Foundation
import SwiftUI

/// Owns navigation state for the Users flow.
@MainActor
final class UserFlowCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    private let graph: UserFlowGraph

    init(container: AppContainer) {
        self.graph = UserFlowGraph(container: container)
    }

    func navigate(to route: UserFlowRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func destination(for route: UserFlowRoute) -> AnyView {
        graph.destination(for: route, coordinator: self)
    }
}

