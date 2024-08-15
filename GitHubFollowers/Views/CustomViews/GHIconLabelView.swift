//
//  GHIconLabelView.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 14/8/24.
//

import UIKit

class GHIconLabelView: UIView {
    var iconName: String? {
        didSet {
            if let iconName = iconName {
                iconView.image = UIImage(systemName: iconName)
            }
        }
    }

    var labelText: String? {
        didSet {
            if labelText != nil {
                label.text = labelText
            }
        }
    }

    private let iconView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "smallcircle.filled.circle.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .systemGreen
        return image
    }()

    private let label: GHBodyLabel = {
        let label = GHBodyLabel(textAlignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "unknown")
        return label
    }()

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        addSubview(label)

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor),
            //
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

#Preview {
    let vc = GHIconLabelView()
    vc.iconName = "location"
    vc.labelText = "Jacó, Costa Rica"
    return vc
}
