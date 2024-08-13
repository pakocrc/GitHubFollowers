//
//  GitHubButton.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 8/8/24.
//

import UIKit

final class GitHubButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }

    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

#Preview {
    GitHubButton(backgroundColor: .systemGreen, title: "Title")
}

// -MARK: Enable/Disable

/*
 //
 //  GitHubButton.swift
 //  GitHubFollowers
 //
 //  Created by Francisco Cordoba on 8/8/24.
 //

 import UIKit

 final class GitHubButton: UIButton {
     var action: (() -> Void) = {}
     var buttonEnabled: Bool {
         get {
             return isEnabled
         }
         set {
             isEnabled = newValue
             backgroundColor = isEnabled ? .systemGreen : .systemGray
         }
     }

     override init(frame: CGRect) {
         super.init(frame: frame)
         configure()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     init(title: String) {
         super.init(frame: .zero)
         self.setTitle(title, for: .normal)
         configure()
     }

     private func configure() {
         layer.cornerRadius = 10
         titleLabel?.textColor = .white
         titleLabel?.font = .preferredFont(forTextStyle: .headline)
         translatesAutoresizingMaskIntoConstraints = false
         backgroundColor = .systemGray
         isEnabled = false
     }
 }

 #Preview {
     GitHubButton(title: "Title")
 }

 */
