//
//  FollowersListVC.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 12/8/24.
//

import UIKit

final class FollowersListVC: UIViewController {

    enum Section: CaseIterable { case main }

    private let username: String
    private var followers  = [Follower](), filteredFollowers = [Follower]()
//    {
//        didSet {
//            self.page += 1
//            self.updateData()
//        }
//    }

    private var page = 1
    private var hasMoreFollowers = true
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    private var emptyView: GHEmptyVC?

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
        configureSeachController()
    }

    private func configureNavigationBar() {
        title = username
        navigationController?.navigationBar.isHidden = false
    }

    private func getFollowers() {
        presentLoadingViewOnMainThread()

        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }

            self.dismissLoadingView()
            switch result {
                case .success(let followers):

                    print("⭐️ Followers count for: \(username) = \(followers.count). Page: \(page)")
                    if followers.count < 100 { self.hasMoreFollowers = false }
                    self.page += 1
                    self.followers.append(contentsOf: followers)
                    self.updateData(with: self.followers)

                    if followers.isEmpty { self.showEmptyView() }

                case .failure(let errorMessage):
                    self.presentAlertOnMainThread(title: String(localized: "error"),
                                                  message: errorMessage.rawValue,
                                                  buttonTitle: "ok")
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

    func configureSeachController() {
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.placeholder                  = String(localized: "search")
        searchController.obscuresBackgroundDuringPresentation   = true
        navigationItem.searchController                         = searchController
    }

#if DEBUG
    deinit { print("FollowersListVC deinit 🗑️") }
#endif
}

extension FollowersListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
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

extension FollowersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            updateData(with: self.followers)
            return
        }

        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })

        updateData(with: filteredFollowers)
    }
}

#Preview {
    let vc = FollowersListVC(username: "pakocrc")
//    vc.followers = debugFollowers
    return vc
}
