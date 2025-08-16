//
//  UserListViewModel.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import Foundation

final class UserListViewModel: ObservableObject {
    @Published var isShowLoading = false
    @Published var isShowError = false
    @Published var users: [User] = []

    private var fetchUseCase: GetListUserUseCase
    private var deleteUseCase: DeleteLocalUseCase
    private var page: Int = 0
    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(fetchUseCase: GetListUserUseCase, deleteUseCase: DeleteLocalUseCase) {
        self.fetchUseCase = fetchUseCase
        self.deleteUseCase = deleteUseCase
        fetchUsers()
    }

    /// Fetches a list of users from the data source.
    /// - Note: If it's the first page, a loading indicator will be displayed. If no more users can be fetched, the request will be ignored.
    private func fetchUsers() {
        guard !isLoading else { return }
        isLoading.toggle()
        if page == 0 {
            isShowLoading.toggle()
        }
        fetchUseCase.execute(UserFecthRequest(page: page))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isShowLoading = false
                self.isLoading = false
                if case .failure(_) = completion {
                    self.isShowError = true
                }
            } receiveValue: { [weak self] users in
                if self?.page == 0 {
                    self?.users = users
                } else {
                    self?.users.append(contentsOf: users)
                }
                self?.page += 1
            }
            .store(in: &cancellables)
    }

    /// Checks if more users should be fetched when reaching a certain position in the list.
    /// - Parameter item: The user item being checked for its position.
    /// - Note: If the item is within the last 5 users, it triggers fetching additional users.
    func checkForMore(_ item: User) {
        let thresholdIndex = users.index(users.endIndex, offsetBy: -5)
        if users.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            // function to request more data
            fetchUsers()
        }
    }

    /// Refreshes the user list by clearing cached data and fetching the first page again.
    func refresh() {
        deleteUseCase.execute()
            .sink { completion in
                if case .failure(_) = completion {
                    self.isShowError = true
                }
            } receiveValue: { [weak self] _ in
                self?.page = 0
                self?.fetchUsers()
            }
            .store(in: &cancellables)
    }
}