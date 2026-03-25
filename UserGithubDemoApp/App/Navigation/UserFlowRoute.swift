//
//  UserFlowRoute.swift
//  UserGithubDemoApp
//

import Foundation

/// Routes inside the Users flow (list -> detail).
enum UserFlowRoute: Hashable {
    case userList
    case userDetail(name: String)
}

