//
//  DebugData.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import Foundation

#if DEBUG
let debugFollowers = [
    Follower(login: "dpacassi", avatarURL: "https://avatars.githubusercontent.com/u/10364195?v=4", id: 10364195),
    Follower(login: "pandermatt", avatarURL: "https://avatars.githubusercontent.com/u/20790833?v=4", id: 20790833),
    Follower(login: "jschuerch", avatarURL: "https://avatars.githubusercontent.com/u/43876424?v=4", id: 43876424)
]
let debugUserInfo = User(login: "andrew",
                         avatarURL: "https://avatars.githubusercontent.com/u/1060?v=4",
                         createdAt: "2008-02-27T11:39:22Z",
                         htmlUrl: "www.github.com/pakocrc",
                         id: 1060,
                         publicRepos: 309,
                         publicGists: 196,
                         followers: 3198,
                         following: 3257,
                         name: Optional("Andrew Nesbitt"),
                         location: Optional("Bristol, UK"),
                         bio: Optional("Working on mapping the world of open source software @ecosyste-ms  and empowering developers with @octobox "))
#endif
