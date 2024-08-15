//
//  UIViewController+PresentFullScreen.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import Foundation
import UIKit

extension UIViewController {

    func presentAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = GHAlertVC(alertTitle: title, alertMessage: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(alertVC, animated: true)
        }
    }

    func presentLoadingView() {
        let loadingVC = GHLoadingVC()
        loadingVC.modalPresentationStyle = .overFullScreen
        loadingVC.modalTransitionStyle = .crossDissolve

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(loadingVC, animated: true)
        }
    }

    func dismissLoadingView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
}
