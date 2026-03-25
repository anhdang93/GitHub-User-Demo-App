//
//  UserFlowGraph.swift
//  UserGithubDemoApp
//

import SwiftUI

/// Route graph for the Users flow.
struct UserFlowGraph {
    let container: AppContainer

    func destination(for route: UserFlowRoute, coordinator: UserFlowCoordinator) -> AnyView {
        switch route {
        case .userList:
            let viewModel = container.makeUserListViewModel()
            return AnyView(
                UserListView(
                    viewModel: viewModel,
                    onSelectUser: { user in
                        coordinator.navigate(to: .userDetail(name: user.name))
                    }
                )
            )

        case .userDetail(let name):
            let viewModel = container.makeUserDetailViewModel(name: name)
            return AnyView(UserDetailView(viewModel: viewModel))
        }
    }
}

