//
//  UserProtocol.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Foundation
import SwiftData

protocol UserProtocol: Identifiable {
    var id: UUID { get set }
    var name: String { get set }
    var avatar: String { get set }
    var githubURL: String { get set }
}