//
//  representing.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine

// A protocol representing a use case that requires an input request to execute.
protocol UseCase {
    associatedtype Request
    associatedtype Response

    func execute(_ request: Request) -> AnyPublisher<Response, Error>
}

/// A protocol representing a use case that does not require an input request to execute.
protocol UseCaseNoRequest {
    associatedtype Response

    func execute() -> AnyPublisher<Response, Error>
}