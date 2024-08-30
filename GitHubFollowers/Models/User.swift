//
//  User.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import Foundation

struct User: Codable {
    let login, avatarURL, createdAt, htmlUrl: String
    let id, publicRepos, publicGists, followers, following: Int
    let name, location, bio: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case name, location, bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers, following
        case createdAt = "created_at"
        case htmlUrl = "html_url"
    }
}
