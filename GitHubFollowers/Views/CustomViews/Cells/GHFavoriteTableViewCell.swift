//
//  GHFavoriteTableViewCell.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 30/8/24.
//

import UIKit

final class GHFavoriteTableViewCell: UITableViewCell {
    static let reuseIdentifier = "GHFavoriteTableViewCell"

    private let avatarImage = GHAvatarImageView(frame: .zero)
    private let usernameLabel = GHTitleLabel(textAlignment: .center, fontSize: 26)
    private let padding = CGFloat(8)

    var follower: Follower? {
        didSet {
            guard let follower = follower else { return }
            avatarImage.downloadImage(from: follower.avatarURL)
            usernameLabel.title = follower.login
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(avatarImage)
        addSubview(usernameLabel)

        usernameLabel.textAlignment = .left

        accessoryType = .disclosureIndicator

        backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            avatarImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImage.widthAnchor.constraint(equalToConstant: 50.0),
            avatarImage.heightAnchor.constraint(equalToConstant: 50.0),
            //
            usernameLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: padding * 2),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.bottomAnchor.constraint(equalTo: avatarImage.bottomAnchor)
        ])
    }
}

#Preview {
    let cell = GHFavoriteTableViewCell(frame: .zero)
    cell.follower = debugFollowers.first!
    return cell
}
