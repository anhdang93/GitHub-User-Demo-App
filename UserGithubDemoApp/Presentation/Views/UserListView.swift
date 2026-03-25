//
//  UserListView.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import Combine
import SwiftData
import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel
    private let onSelectUser: (User) -> Void

    init(
        viewModel: UserListViewModel,
        onSelectUser: @escaping (User) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSelectUser = onSelectUser
    }

    var body: some View {
        ZStack {
            if viewModel.isShowLoading {
                ProgressView("Loading Users...")
                    .padding()
            } else {
                List {
                    ForEach(viewModel.users) { user in
                        UserRow(user: user)
                            .onAppear {
                                viewModel.checkForMore(user)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onSelectUser(user)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    viewModel.refresh()
                }
            }
        }
        .navigationTitle("Github Users")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $viewModel.isShowError) {
            Button(action: { }, label: {
                Text("OK")
            })
        } message: {
            Text("There is error, please try again later")
        }
    }
}

#Preview {
    let repository = PreviewUserRepository()
    let viewModel = UserListViewModel(
        fetchUseCase: GetListUserUseCase(repository: repository),
        deleteUseCase: DeleteLocalUseCase(repository: repository)
    )
    UserListView(viewModel: viewModel, onSelectUser: { _ in })
}