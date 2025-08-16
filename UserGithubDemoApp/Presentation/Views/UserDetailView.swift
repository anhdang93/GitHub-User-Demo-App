//
//  UserDetailView.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import SwiftUI

struct UserDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: UserDetailViewModel

    init(name: String) {
        let useCase = GetUserDetailUseCase(repository: ServiceLocator.shared.resolve())
        _viewModel = StateObject(
            wrappedValue: UserDetailViewModel(name: name, useCase: useCase)
        )
    }

    var body: some View {
        VStack {
            ZStack {
                if viewModel.isLoading {
                    // Show a loading indicator while data is being fetched
                    ProgressView("Loading user details...")
                } else if let user = viewModel.user {
                    VStack(alignment: .leading) {
                        VStack(spacing: 30) {
                            UserRow(user: user)

                            HStack(spacing: 80) {
                                VStack {
                                    Image(systemName: "person.2.circle.fill")
                                        .resizable()
                                        .foregroundStyle(.gray)
                                        .frame(width: 40, height: 40)
                                    Text(viewModel.followerCount)
                                    Text("Followers")
                                }

                                VStack {
                                    Image(systemName: "trophy.circle.fill")
                                        .resizable()
                                        .foregroundStyle(.gray)
                                        .frame(width: 40, height: 40)
                                    Text(viewModel.followingCount)
                                    Text("Following")
                                }
                            }
                        }

                        Text("Blog")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .padding(.top, 20)
                            .padding(.bottom, 10)

                        Text(user.blog)
                            .foregroundStyle(.gray)
                            .onTapGesture {
                                viewModel.openBlog()
                            }

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("User Details") // Title for the screen
            .navigationBarTitleDisplayMode(.inline) // Compact title
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                }
            }
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
    UserDetailView(name: "mojombo")
}