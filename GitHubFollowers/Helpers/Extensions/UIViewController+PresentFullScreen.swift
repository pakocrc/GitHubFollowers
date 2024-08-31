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

            self.present(alertVC, animated: true) {
                print("🟠 On presenting alert!")
            }
        }
    }

    func presentLoadingView(_ viewController: GHLoadingVC) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.present(viewController, animated: true) {
                print("🟠 On present loading view!")
            }
        }
    }

    func dismissLoadingView(_ viewController: GHLoadingVC, action: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            viewController.dismissView()
            action?()
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
