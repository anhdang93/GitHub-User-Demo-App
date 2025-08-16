//
//  UserListView.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import SwiftData
import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel

    init() {
        let fetchUseCase = GetListUserUseCase(repository: ServiceLocator.shared.resolve())
        let deleteUseCase = DeleteLocalUseCase(repository: ServiceLocator.shared.resolve())

        _viewModel = StateObject(
            wrappedValue: UserListViewModel(fetchUseCase: fetchUseCase, 
                                            deleteUseCase: deleteUseCase)
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isShowLoading {
                    ProgressView("Loading Users...")
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            ZStack {
                                UserRow(user: user)
                                    .onAppear {
                                        viewModel.checkForMore(user)
                                    }
                                NavigationLink(destination: UserDetailView(name: user.name)) {
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: 0)
                                .opacity(0)
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
}

#Preview {
    UserListView()
}