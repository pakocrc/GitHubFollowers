//
//  FollowersListVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 12/8/24.
//

import UIKit

final class FollowersListVC: UIViewController {
    let username: String

    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureNavigationBar() {
        title = username
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
    }

    deinit {
        print("FollowersListVC deinit 🗑️")
    }
}
