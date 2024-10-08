//
//  FollowersListVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 12/8/24.
//

import UIKit

protocol FollowersListVCDelegate: AnyObject {
    func onReloadFollowersList(for user: User)
}

final class FollowersListVC: UIViewController {

    enum Section: CaseIterable { case main }

    private var username: String
    private var followers  = [Follower](), filteredFollowers = [Follower]()

    private var page = 1
    private var hasMoreFollowers = true
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    private var emptyView: GHEmptyVC?
    private var isSearching = false
    private var isNewUserList = false
    private let loadingVC = GHLoadingVC()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        searchController.showsSearchResultsController = true
        searchController.searchBar.delegate = self
        return searchController
    }()

    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        getFollowers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureUI() {
        configureCollectionView()
        configureDataSource()
    }

    private func configureNavigationBar() {
        title = username
        navigationController?.navigationBar.isHidden = false
        navigationItem.searchController = searchController

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFavoriteUserButtonTapped))
        navigationItem.rightBarButtonItem = addButton

        verifyIfUserIsFavorite()
    }

    @objc
    private func popViewController() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func verifyIfUserIsFavorite() {
        PersistenceManger.retrieveFavorites { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let favorites):

                    if !favorites.contains(where: { $0.login == self.username }) {
                        self.showHideAddFavoriteButton(show: true)
                    } else {
                        self.showHideAddFavoriteButton(show: false)
                    }
                case .failure:
                    self.showHideAddFavoriteButton(show: false)
            }
        }
    }

    private func showHideAddFavoriteButton(show: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            navigationItem.rightBarButtonItem?.isHidden = !show
            navigationItem.rightBarButtonItem?.isEnabled = show
        }
    }

    private func getFollowers() {
        presentLoadingView(loadingVC)

        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let followers):

                    dismissLoadingView(loadingVC)

                    isNewUserList = false

                    print("⭐️ Followers count for: \(username) = \(followers.count). Page: \(page)")
                    if followers.count < 100 { self.hasMoreFollowers = false }
                    self.page += 1
                    self.followers.append(contentsOf: followers)
                    self.updateData(with: self.followers)

                    if followers.isEmpty { self.showEmptyView() }

                case .failure(let errorMessage):
                    dismissLoadingView(loadingVC) {
                        self.presentAlert(title: String(localized: "error"),
                                          message: errorMessage.rawValue,
                                          buttonTitle: "ok")

                        if self.isNewUserList {
                            var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
                            snapshot.deleteAllItems()

                            self.dataSource.apply(snapshot, animatingDifferences: true)
                        }
                    }
            }
        }
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: .createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GHFollowerCollectionViewCell.self, forCellWithReuseIdentifier: GHFollowerCollectionViewCell.resusableID)
        collectionView.delegate = self
    }

    private func configureDataSource() {
        dataSource =
        UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider:
                                                                            { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GHFollowerCollectionViewCell.resusableID, for: indexPath) as? GHFollowerCollectionViewCell {
                cell.setFollower(follower: follower)
                return cell
            }

            return UICollectionViewCell()
        })
    }

    // MARK: - Update Data
    private func updateData(with followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(followers)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    private func showEmptyView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let emptyView = GHEmptyVC(titleMessage: String(localized: "not_followers_message")).view {
                view.addSubview(emptyView)
            }
        }
    }

    private func getUserInfo(username: String) {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let user):

                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let vc = UserInfoVC(userInfo: user)
                        vc.delegate = self
                        let navController = UINavigationController(rootViewController: vc)
                        present(navController, animated: true)
                    }

                case .failure(let failure):
                    presentAlert(title: "error", message: failure.localizedDescription, buttonTitle: "ok")
            }
        }
    }

    @objc
    private func addFavoriteUserButtonTapped() {
        presentLoadingView(loadingVC)

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let userInfo):

                    dismissLoadingView(loadingVC)

                    let follower = Follower(login: userInfo.login, avatarURL: userInfo.avatarURL, htmlUrl: userInfo.htmlUrl, id: userInfo.id)

                    PersistenceManger.updateFavoritesList(with: follower, actionType: .add) { [weak self] error in
                        guard let self = self else { return }

                        if error != nil {
                            self.dismissLoadingView(self.loadingVC) {
                                self.presentAlert(title: String(localized: "error"),
                                                  message: error?.localizedDescription ?? "",
                                                  buttonTitle: "ok")
                            }
                        }

                        self.dismissLoadingView(self.loadingVC) {
                            self.presentAlert(title: String(localized: "Success"),
                                              message: String(localized: "Favorite included"),
                                              buttonTitle: String(localized: "ok"))
                        }
                    }

                    verifyIfUserIsFavorite()

                case .failure(let failure):
                    dismissLoadingView(loadingVC) {
                        self.presentAlert(title: "error",
                                          message: failure.localizedDescription,
                                          buttonTitle: "ok")
                    }
            }
        }
    }

    deinit { print("FollowersListVC deinit 🗑️") }
}

extension FollowersListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentArray = isSearching ? filteredFollowers : followers
        let username = currentArray[indexPath.item].login
        getUserInfo(username: username)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height

        if offsetY > contentHeight - height, hasMoreFollowers == true {
            getFollowers()
        }
    }
}

extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {

        if let filter = searchController.searchBar.text, !filter.isEmpty {
            isSearching = true
            filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
            updateData(with: filteredFollowers)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(with: followers)
    }
}

extension FollowersListVC: FollowersListVCDelegate {
    func onReloadFollowersList(for user: User) {
        username = user.login
        title = username
        page = 1
        isNewUserList = true
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers()
        verifyIfUserIsFavorite()
    }
}

#Preview {
    let vc = FollowersListVC(username: "pakocrc")
//    vc.followers = debugFollowers
    return vc
}
