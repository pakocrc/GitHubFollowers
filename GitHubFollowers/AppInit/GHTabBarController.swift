//
//  GHTabBarController.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 30/8/24.
//

import UIKit

class GHTabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let searchNC = createSearchNavigationController()
        let favoritesNC = createFavoritesNavigationController()

        viewControllers = [searchNC, favoritesNC]
        tabBar.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSearchNavigationController() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = String(localized: "Search")
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        return UINavigationController(rootViewController: searchVC)
    }

    private func createFavoritesNavigationController() -> UINavigationController {
        let favoritesVC = FavoritesListVC()
        favoritesVC.title = String(localized: "Favorites")
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        return UINavigationController(rootViewController: favoritesVC)
    }

    private func createTabBarController() -> UITabBarController {
        let searchNC = createSearchNavigationController()
        let favoritesNC = createFavoritesNavigationController()

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [searchNC, favoritesNC]
        tabBarController.tabBar.backgroundColor = .white

        return tabBarController
    }
}
