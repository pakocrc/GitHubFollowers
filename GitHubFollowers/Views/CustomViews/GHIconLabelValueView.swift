//
//  GHIconLabelValueView.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 14/8/24.
//

import UIKit

class GHIconLabelValueView: UIView {
    var iconName: String? {
        didSet {
            iconLabelView.iconName = iconName
        }
    }

    var labelText: String? {
        didSet {
            iconLabelView.labelText = labelText
        }
    }

    var valueText: String? {
        didSet {
            valueLabel.text = valueText
        }
    }

    private let iconLabelView: GHIconLabelView = {
        let labelView = GHIconLabelView()
        return labelView
    }()

    private let valueLabel: GHBodyLabel = {
        let label = GHBodyLabel(textAlignment: .center)
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "0"
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
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconLabelView)
        addSubview(valueLabel)

        NSLayoutConstraint.activate([
            iconLabelView.topAnchor.constraint(equalTo: topAnchor),
            iconLabelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconLabelView.widthAnchor.constraint(equalTo: widthAnchor),
            iconLabelView.heightAnchor.constraint(equalToConstant: 20),
            //
            valueLabel.topAnchor.constraint(equalTo: iconLabelView.bottomAnchor, constant: 10),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.widthAnchor.constraint(equalTo: widthAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

#Preview {
    let vc = GHIconLabelValueView()
    vc.iconName = "folder"
    vc.labelText = String(localized: "public_repos")
    vc.valueText = "46"
    return vc
}
