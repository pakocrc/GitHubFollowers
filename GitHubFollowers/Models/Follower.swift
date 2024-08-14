//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import Foundation

struct Follower: Codable, Hashable {
    let login, avatarURL: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
