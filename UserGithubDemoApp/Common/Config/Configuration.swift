//
//  Configuration.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//

import Foundation

/// A configuration class that provides constants for network requests.
class Configuration {
    /// The base URL for the GitHub API.
    static let baseURL = "https://api.github.com"

    /// The default HTTP headers used for network requests.
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
}
