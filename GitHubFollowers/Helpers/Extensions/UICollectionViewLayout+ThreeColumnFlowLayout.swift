//
//  UICollectionViewLayout+ThreeColumnFlowLayout.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import UIKit

extension UICollectionViewLayout {
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewLayout {
        let width = view.bounds.width
        let padding = CGFloat(12)
        let minimumItemSpacing = CGFloat(10)
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)

        return flowLayout
    }
}
