//
//  GHLoadingVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import UIKit

final class GHLoadingVC: UIViewController {

    private let blurredView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .lightGray
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(blurredView)
        view.addSubview(activityIndicator)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            blurredView.topAnchor.constraint(equalTo: view.topAnchor),
            blurredView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurredView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurredView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    func dismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }

    deinit { print("GHLoadingVC deinit 🗑️") }
}

#Preview {
    GHLoadingVC()
}
