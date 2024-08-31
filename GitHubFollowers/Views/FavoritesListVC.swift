//
//  FavoritesListVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 8/8/24.
//

import UIKit

final class FavoritesListVC: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var favorites = [Follower]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        retrieveFavorites()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveFavorites()
    }

    private func setupNavigationBar() {
        title = String(localized: "Favorites")
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func retrieveFavorites() {
        PersistenceManger.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let followers):
                    guard !followers.isEmpty else {
                        self.showEmptyView()
                        return
                    }
                    self.favorites = followers
                    self.tableView.reloadData()

                case .failure(let failure):
                    self.presentAlert(title: "error", message: failure.localizedDescription, buttonTitle: "ok")
                    self.showEmptyView()
            }
        }
    }

    private func showEmptyView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let emptyView = GHEmptyVC(titleMessage: String(localized: "Not favorites yet")).view {
                view.addSubview(emptyView)
            }
        }
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.frame = view.bounds
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = .systemBackground
        tableView.register(GHFavoriteTableViewCell.self, forCellReuseIdentifier: GHFavoriteTableViewCell.reuseIdentifier)
    }

    private func presentUserInfo(favorite: Follower) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let vc = FollowersListVC(username: favorite.login)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func removeFavoriteUser(favorite: Follower, indexPath: IndexPath) {
        PersistenceManger.updateFavoritesList(with: favorite, actionType: .remove) { error in
            if error != nil {
                self.presentAlert(title: String(localized: "error"),
                                  message: error?.localizedDescription ?? "",
                                  buttonTitle: String(localized: "accept"))
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.favorites.removeAll(where: { $0.login == favorite.login })
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GHFavoriteTableViewCell.reuseIdentifier) as? GHFavoriteTableViewCell else {
            return UITableViewCell()
        }

        cell.follower = favorites[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFavotite = favorites[indexPath.row]
        presentUserInfo(favorite: selectedFavotite)

        tableView.deselectRow(at: indexPath, animated: true)
    }

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        return UISwipeActionsConfiguration(actions: [
//
//            UIContextualAction(style: .destructive, title: String(localized: "Remove"), handler: { _, _, _ in
//                let favoriteSelected = self.favorites[indexPath.row]
//                self.removeFavoriteUser(favorite: favoriteSelected, indexPath: indexPath)
//            })
//        ])
//    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let favorite = favorites[indexPath.row]
        self.removeFavoriteUser(favorite: favorite, indexPath: indexPath)
    }
}

#Preview {
    FavoritesListVC()
}
