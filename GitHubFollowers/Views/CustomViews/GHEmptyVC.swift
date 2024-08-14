//
//  GHEmptyVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import UIKit

final class GHEmptyVC: UIViewController {

    private let titleMessage: String

    private let titleLabel: GHTitleLabel = {
        let label = GHTitleLabel(textAlignment: .center, fontSize: 26)
        label.numberOfLines = 0
        return label
    }()

    private let backgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: GHImages.emptyStateLogo.rawValue))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(titleMessage: String) {
        self.titleMessage = titleMessage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(backgroundImage)

        titleLabel.title = titleMessage

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalToConstant: 300),
            //
            backgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

#Preview {
    GHEmptyVC(titleMessage: String(localized: "not_followers_message"))
}
