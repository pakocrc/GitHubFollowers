//
//  GHAlertVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 12/8/24.
//

import UIKit

final class GHAlertVC: UIViewController {
    let alertTitle: String
    let alertMessage: String
    let buttonTitle: String

    let titleLabel = GHTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GHBodyLabel(textAlignment: .center)

    private let padding: CGFloat = 20

    lazy var actionButton: GHButton = {
        let button = GHButton(backgroundColor: .systemGreen)
        button.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        return button
    }()

    let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    init(alertTitle: String, alertMessage: String, buttonTitle: String) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureUI()
    }

    private func configureUI() {
        view.addSubview(containerView)

        titleLabel.title = alertTitle
        messageLabel.message = alertMessage
        actionButton.buttonTitle = buttonTitle

        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(actionButton)

        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 250),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            // Title label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            // Message label
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -padding),
            // Button
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding)
        ])
    }

    @objc
    private func closeAlert() {
        dismiss(animated: true)
    }

    deinit {
        print("GitHubAlertVC deinit 🗑️")
    }
}

#Preview {
    GHAlertVC(alertTitle: "Title", alertMessage: "Message", buttonTitle: "Ok")
}
