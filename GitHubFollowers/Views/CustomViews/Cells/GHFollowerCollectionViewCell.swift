//
//  GHFollowerCollectionViewCell.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import UIKit

final class GHFollowerCollectionViewCell: UICollectionViewCell {
    static let resusableID = "GHFollowerCollectionViewCell"

    let avatarImage = GHAvatarImageView(frame: .zero)
    let usernameLabel = GHTitleLabel(textAlignment: .center, fontSize: 16)
    let padding = CGFloat(8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFollower(follower: Follower) {
        usernameLabel.title = follower.login
        avatarImage.downloadImage(from: follower.avatarURL)
    }

    private func configure() {
        addSubview(avatarImage)
        addSubview(usernameLabel)

        backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
            //
            usernameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: padding),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
}

#Preview {
    let cell = GHFollowerCollectionViewCell(frame: .zero)
    cell.setFollower(follower: debugFollowers.first!)
    return cell
}
