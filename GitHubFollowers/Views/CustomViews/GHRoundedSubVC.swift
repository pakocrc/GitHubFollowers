//
//  GHRoundedSubVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 14/8/24.
//

import UIKit

class GHRoundedSubVC: UIViewController {
    var buttonTitle: String? {
        didSet {
            actionButton.buttonTitle = buttonTitle
        }
    }

    var leftIconLabelText: String? {
        didSet {
            leftIconLabel.labelText = leftIconLabelText
        }
    }

    var leftIconName: String? {
        didSet {
            leftIconLabel.iconName = leftIconName
        }
    }

    var leftIconValueText: String? {
        didSet {
            leftIconLabel.valueText = leftIconValueText
        }
    }

    var rightIconLabelText: String? {
        didSet {
            rightIconLabel.labelText = rightIconLabelText
        }
    }

    var rightIconName: String? {
        didSet {
            rightIconLabel.iconName = rightIconName
        }
    }

    var rightIconValueText: String? {
        didSet {
            rightIconLabel.valueText = rightIconValueText
        }
    }

    private let leftIconLabel = GHIconLabelValueView()
    private let rightIconLabel = GHIconLabelValueView()
    let actionButton = GHButton(backgroundColor: .systemPurple)
    private let padding = CGFloat(20)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10

        leftIconLabel.backgroundColor = .secondarySystemBackground
        rightIconLabel.backgroundColor = .secondarySystemBackground

        view.addSubview(leftIconLabel)
        view.addSubview(rightIconLabel)
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([
            leftIconLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            leftIconLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            leftIconLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            leftIconLabel.heightAnchor.constraint(equalToConstant: 60),
            //
            rightIconLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            rightIconLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            rightIconLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            rightIconLabel.heightAnchor.constraint(equalToConstant: 60),
            //
            actionButton.topAnchor.constraint(equalTo: leftIconLabel.bottomAnchor, constant: padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    deinit { print("GHRoundedSubVC deinit 🗑️") }
}

#Preview {
    let vc = GHRoundedSubVC()
    return vc
}
