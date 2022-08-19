
//
//  FavoritePostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 04.08.2022.
//
import UIKit

class FavoritePostsViewController: UIViewController {

    //MARK: Constants
    private let searchBar: UIImage? = ImagesStorage.searchBar

    private let detailPostsImagesTableViewCell: String = "\(DetailPostsImagesTableViewCell.self)"
    private let detailPostsTitlesTableViewCell: String = "\(DetailPostsTitlesTableViewCell.self)"
    private let detailPostsBodiesShortedTableViewCell: String = "\(DetailPostsBodiesShortedTableViewCell.self)"
    private let alertViewText: String = "Are you sure you want to delete from favourites?"
    private let numberOfRows = 3

    //MARK: - Views
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    @IBOutlet private weak var emptyFavoritesNotificationImage: UIImageView!
    @IBOutlet private weak var emptyFavoritesNotificationText: UILabel!

    //MARK: - Singleton instances
    private let postModel: AllPostsModel = AllPostsModel.shared

    //MARK: - Public properties
    static var favoriteTapStatus: Bool = false
    static var successLoadingPostsAfterZeroScreen: Bool = false

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configurePullToRefresh()
        configureModel()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        if !(postModel.favoritePosts.isEmpty) && FavoritePostsViewController.successLoadingPostsAfterZeroScreen {
            nonEmptyFavoritesNotification()
            tableView.reloadData()
            FavoritePostsViewController.successLoadingPostsAfterZeroScreen = false
        }
        if FavoritePostsViewController.favoriteTapStatus {
            tableView.reloadData()
            FavoritePostsViewController.favoriteTapStatus = false
        }
    }
}
//MARK: - Private methods
private extension FavoritePostsViewController {
    func configureAppearance() {
        configureTableView()
    }

    func configureNavigationBar() {
        navigationItem.title = "Favourites"
        let searchButton = UIBarButtonItem(image: searchBar,
                style: .plain,
                target: self,
                action: #selector(goToSearchVC(sender:)))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = ColorsStorage.black
    }

    func configureModel() {
        postModel.didPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.tableView.reloadData()
                self.postModel.favoritePosts.isEmpty ? self.emptyFavoritesNotification() : self.nonEmptyFavoritesNotification()

            }
        }
    }
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.register(UINib(nibName: detailPostsImagesTableViewCell, bundle: .main), forCellReuseIdentifier: detailPostsImagesTableViewCell)
        tableView.register(UINib(nibName: detailPostsTitlesTableViewCell, bundle: .main), forCellReuseIdentifier: detailPostsTitlesTableViewCell)
        tableView.register(UINib(nibName: detailPostsBodiesShortedTableViewCell, bundle: .main), forCellReuseIdentifier: detailPostsBodiesShortedTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }

    func configurePullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = ColorsStorage.lightGray
        refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        tableView.addSubview(refreshControl)
    }
    @objc func pullToRefresh(_ sender: AnyObject) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    func emptyFavoritesNotification() {
        refreshControl.removeFromSuperview()
        view.bringSubviewToFront(emptyFavoritesNotificationImage)
        view.bringSubviewToFront(emptyFavoritesNotificationText)
        emptyFavoritesNotificationImage.image = ConstantImages.sadSmile
        emptyFavoritesNotificationText.font = .systemFont(ofSize: 14, weight: .light)
        emptyFavoritesNotificationText.text = "the favourites are empty"
    }
    func nonEmptyFavoritesNotification() {
        configurePullToRefresh()
        emptyFavoritesNotificationImage.image = UIImage()
        emptyFavoritesNotificationText.text = ""
    }
}



//MARK: - TableView DataSource
extension FavoritePostsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return postModel.favoritePosts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailPostsImagesTableViewCell.self)")
            if let cell = cell as? DetailPostsImagesTableViewCell {
                let currentPost = postModel.favoritePosts[indexPath.section]
                cell.imageUrlInString = currentPost.imageUrlInString
                cell.isFavorite = currentPost.isFavorite
                cell.postTextLabel = currentPost.title
                cell.didFavoriteTap = { [weak self] in
                    guard let `self` = self else { return }
                    appendConfirmingAlertView(for: self, text: self.alertViewText) { action in
                        let favoritesStorage: FavoritesStorage = FavoritesStorage.shared

                        if favoritesStorage.isPostFavorite(post: currentPost.title) {
                            favoritesStorage.removeFavorite(favoritePost: currentPost.title)
                        } else {
                            favoritesStorage.addFavorite(favoritePost: currentPost.title)
                        }
                        cell.isFavorite.toggle()
                        let favoritePost = self.postModel.favoritePosts[indexPath.section]
                        self.postModel.favoritePost(for: favoritePost)
                        self.tableView.reloadData()
                        self.postModel.favoritePosts.isEmpty ? self.emptyFavoritesNotification() : self.nonEmptyFavoritesNotification()
                    }
                }
            }

            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailPostsTitlesTableViewCell)
            if let cell = cell as? DetailedPostTitleTableViewCell {
                cell.titlesText = postModel.favoritePosts[indexPath.section].title
                cell.titlesDate = postModel.favoritePosts[indexPath.section].dateCreation
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailPostsBodiesShortedTableViewCell)
            if let cell = cell as? DetailPostsBodiesShortedTableViewCell {
                cell.bodiesText = postModel.favoritePosts[indexPath.section].content
            }
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailPostsViewController()
        vc.model = self.postModel.favoritePosts[indexPath.section]
        navigationController?.pushViewController(vc, animated: true)
    }
}

