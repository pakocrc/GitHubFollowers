//
//  UIViewController+PresentFullScreen.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController {

    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let alertVC = GHAlertVC(alertTitle: title, alertMessage: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve

            self.present(alertVC, animated: true)
        }
    }

    func presentLoadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let loadingVC = GHLoadingVC()
            loadingVC.modalPresentationStyle = .overFullScreen
            loadingVC.modalTransitionStyle = .crossDissolve

            self.present(loadingVC, animated: true)
        }
    }

    func dismissLoadingView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }

    func presentSafariVC(with url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredControlTintColor = .systemGreen
            present(safariVC, animated: true)
        }
    }
}
