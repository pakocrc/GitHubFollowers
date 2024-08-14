//
//  GHAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import UIKit

final class GHAvatarImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = UIImage(named: GHImages.avatarPlaceholder.rawValue)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func downloadImage(from urlString: String) {

        if let image = NetworkManager.shared.imageCache.object(forKey: NSString(string: urlString)) {
            self.image = image
            return
        }

        guard let url = URL(string: urlString) else { return }

        NetworkManager.shared.downloadImage(with: url) { [weak self] image in
            guard let self = self, let image = image else { return }

            NetworkManager.shared.imageCache.setObject(image, forKey: NSString(string: urlString))

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.image = image
            }
        }
    }
}
