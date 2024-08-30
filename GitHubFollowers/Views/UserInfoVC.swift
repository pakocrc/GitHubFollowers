//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 14/8/24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didTapGitHubProfile()
    func didTapGitHubFollowers()
}

final class UserInfoVC: UIViewController, UserInfoVCDelegate {

    private let userInfo: User

    private let avatarImage = GHAvatarImageView(frame: .zero)
    private let usernameLabel = GHTitleLabel(textAlignment: .center, fontSize: 32)
    private let nameLabel = GHBodyLabel(textAlignment: .center)
    private let locationIconLabel = GHIconLabelView()
    private let bioLabel = GHBodyLabel(textAlignment: .center)
    private let padding = CGFloat(20)
    private let reposVC = GHRoundedSubVC()
    private let followersVC = GHRoundedSubVC()
    private let footerMessage = GHBodyLabel(textAlignment: .center)
    weak var delegate: FollowersListVCDelegate?

    init(userInfo: User) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureHeaderView()
        configureReposView()
        configureFollowersView()
        configureFooterView()
    }

    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .systemBackground

        let dismissButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissView))
        dismissButton.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = dismissButton
    }

    private func configureHeaderView() {
        avatarImage.downloadImage(from: userInfo.avatarURL)
        usernameLabel.title = userInfo.login
        usernameLabel.textAlignment = .left
        nameLabel.text = userInfo.name
        nameLabel.textAlignment = .left
        locationIconLabel.iconName = "location"
        locationIconLabel.labelText = userInfo.location
        bioLabel.text = userInfo.bio
        bioLabel.textAlignment = .natural
        bioLabel.numberOfLines = 0

        view.addSubview(avatarImage)
        view.addSubview(usernameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationIconLabel)
        view.addSubview(bioLabel)

        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            avatarImage.heightAnchor.constraint(equalToConstant: 100),
            avatarImage.widthAnchor.constraint(equalToConstant: 100),
            //
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 50),
            usernameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding),
            //
            nameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            //
            locationIconLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            locationIconLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: padding),
            locationIconLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding),
            locationIconLabel.heightAnchor.constraint(equalToConstant: 25),
            //
            bioLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: padding),
            bioLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            bioLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            bioLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: padding)
        ])
    }

    private func configureReposView() {
        reposVC.buttonType = .profile
        reposVC.delegate = self

        reposVC.buttonTitle = String(localized: "github_profile")
        //
        reposVC.leftIconLabelText = String(localized: "public_repos")
        reposVC.leftIconName = "folder"
        reposVC.leftIconValueText = userInfo.publicRepos.description
        //
        reposVC.rightIconLabelText = String(localized: "public_gists")
        reposVC.rightIconName = "list.bullet"
        reposVC.rightIconValueText = userInfo.publicGists.description

        view.addSubview(reposVC.view)

        NSLayoutConstraint.activate([
            reposVC.view.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: padding),
            reposVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            reposVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            reposVC.view.heightAnchor.constraint(equalToConstant: 170)
        ])
    }

    private func configureFollowersView() {
        followersVC.buttonType = .followers
        followersVC.delegate = self

        followersVC.buttonTitle = String(localized: "get_followers")
        //
        followersVC.leftIconLabelText = String(localized: "following")
        followersVC.leftIconName = "heart"
        followersVC.leftIconValueText = userInfo.following.description
        //
        followersVC.rightIconLabelText = String(localized: "followers")
        followersVC.rightIconName = "person.3"
        followersVC.rightIconValueText = userInfo.followers.description

        view.addSubview(followersVC.view)

        NSLayoutConstraint.activate([
            followersVC.view.topAnchor.constraint(equalTo: reposVC.view.bottomAnchor, constant: padding),
            followersVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            followersVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            followersVC.view.heightAnchor.constraint(equalToConstant: 170)
        ])
    }

    private func configureFooterView() {
        view.addSubview(footerMessage)

        let date = userInfo.createdAt.convertToDisplayFormat()
        footerMessage.message = String(localized: "GitHub since \(date)")

        NSLayoutConstraint.activate([
            footerMessage.topAnchor.constraint(equalTo: followersVC.view.bottomAnchor),
            footerMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footerMessage.heightAnchor.constraint(equalToConstant: 40),
            footerMessage.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    @objc
    private func dismissView() {
        DispatchQueue.main.async { [weak self] in guard let self = self else { return }
            dismiss(animated: true)
        }
    }

    deinit { print("UserInfoVC deinit 🗑️") }
}

extension UserInfoVC {
    func didTapGitHubProfile() {
        guard let url = URL(string: userInfo.htmlUrl) else {
            presentAlert(title: String(localized: "Alert"),
                                     message: String(localized: "Invalid URL"),
                                     buttonTitle: String(localized: "accept"))
            return
        }

       presentSafariVC(with: url)
    }

    func didTapGitHubFollowers() {
        guard userInfo.followers != 0 else {
            self.presentAlert(title: String(localized: "error"),
                                          message: "User has no followers.",
                                          buttonTitle: "ok")
            return
        }

        dismiss(animated: true)
        delegate?.onReloadFollowersList(for: userInfo)
    }
}

#Preview {
    UserInfoVC(userInfo: debugUserInfo)
}
