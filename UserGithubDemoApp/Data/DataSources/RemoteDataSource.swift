//
//  defining.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation

/// A private struct defining the endpoint for user-related network requests.
private struct UserEndPoint: EndPoint {
    var path: String
    var method: HTTPMethod
    var headers: [String : String]?
    var queryParams: [URLQueryItem]?
    var bodyParams: [String : Any]?

    init(path: String = "/users",
         method: HTTPMethod = .get,
         headers: [String : String]? = nil,
         queryParams: [URLQueryItem]? = nil,
         bodyParams: [String : Any]? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParams = queryParams
        self.bodyParams = bodyParams
    }
}

class RemoteDataSource {
    private let remoteService: NetworkService

    init(remoteService: NetworkService) {
        self.remoteService = remoteService
    }

    /// Fetches a list of users based on pagination parameters.
    /// - Parameters:
    ///   - page: The page index for pagination.
    ///   - itemPerPage: The number of items per page.
    /// - Returns: A publisher emitting an array of `User` or an error.
    func fetchUser(page: Int, itemPerPage: Int) -> AnyPublisher<[User], Error> {
        let queryParams = [
            URLQueryItem(name: "per_page", value: "\(itemPerPage)"),
            URLQueryItem(name: "since", value: "\(page * itemPerPage)")
        ]
        let endPoint = UserEndPoint(queryParams: queryParams)
        return remoteService.fetch(endPoint)
            .map { (dtoArray: [UserDTO]) -> [User] in
                dtoArray.map { UserMapper.mapUserFromDTO($0) }
            }
            .eraseToAnyPublisher()
    }

    /// Fetches detailed information about a specific user.
    /// - Parameter name: The name of the user to fetch details for.
    /// - Returns: A publisher emitting `UserDetail` or an error.
    func fetchUserDetail(_ name: String) -> AnyPublisher<UserDetail, Error> {
        let endPoint = UserEndPoint(path: "/users/\(name)", method: .get)
        return remoteService.fetch(endPoint)
            .map { (userDetailDTO: UserDetailDTO) -> UserDetail in
                UserMapper.mapUserDetailFromDTO(userDetailDTO)
            }
            .eraseToAnyPublisher()
    }
}