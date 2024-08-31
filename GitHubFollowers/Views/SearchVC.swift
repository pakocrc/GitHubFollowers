//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 8/8/24.
//

import UIKit

final class SearchVC: UIViewController {

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: GHImages.appLogo.rawValue)
        return imageView
    }()

    let usernameTextField = GHUsernameTextField()

    lazy var callToActionButton: GHButton = {
        let button = GHButton(backgroundColor: .systemGreen)
        button.addTarget(self, action: #selector(onCallToActionButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createDismissTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
//        usernameTextField.text = ""
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        usernameTextField.delegate = self

        callToActionButton.buttonTitle = String(localized: "get_followers")

        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(callToActionButton)

        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            // Text Field
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            // Button
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }

    private func createDismissTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @objc
    private func onCallToActionButtonPressed() {
        pushFollowersListVC(username: usernameTextField.text)
    }

    private func pushFollowersListVC(username: String?) {
        guard let username = username, !username.isEmpty else {
            presentAlert(title: String(localized: "alert_no_username_title"),
                                     message: String(localized: "alert_no_username_message"),
                                     buttonTitle: String(localized: "accept"))
            return
        }
        pushFollowerListVC(username: username)
    }

    private func pushFollowerListVC(username: String) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let viewController = FollowersListVC(username: username)
            self.navigationController?.pushViewController(viewController, animated: true)
        }

    }

    deinit {
        print("SearchVC deinit 🗑️")
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListVC(username: textField.text)
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
//        callToActionButton.buttonEnabled = !(textField.text?.isEmpty ?? false)
    }
}

#Preview {
    SearchVC()
}
