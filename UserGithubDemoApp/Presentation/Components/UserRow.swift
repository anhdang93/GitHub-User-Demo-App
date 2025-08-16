//
//  UserRow.swift
//  UserGithubDemoApp
//
//  Created by Đặng Ngọc Tuấn Anh on 16/8/25.
//


import SwiftUI

struct UserRow: View {

    private var viewModel: UserRowViewModel

    init(user: any UserProtocol) {
        viewModel = UserRowViewModel(user: user)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ZStack {
                AsyncImage(url: viewModel.avatarURL) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                .clipShape(Circle())
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 5)
            .background(
                Color.gray.opacity(0.1)
                    .cornerRadius(8)
            )

            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.name)
                Divider()
                if viewModel.type == .list, let gitHubLink = viewModel.gitHubLink {
                    Text(gitHubLink.absoluteString)
                        .foregroundStyle(.blue)
                        .underline()
                        .onTapGesture {
                            viewModel.openGitHubLink()
                        }
                } else {
                    HStack {
                        Image(systemName: "location.circle.fill")
                            .foregroundStyle(.gray)
                        Text(viewModel.location)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(content: {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        })
        .background(
            Rectangle()
                .fill(.white)
                .cornerRadius(8)
                .shadow(
                    color: .gray.opacity(0.5),
                    radius: 5,
                    x: 0,
                    y: 5)
        )
    }
}

#Preview {
    UserRow(
        user: User(name: "mojombo",
                   avatar: "https://avatars.githubusercontent.com/u/1?v=4",
                   githubURL: "https://github.com/mojombo")
    )
}