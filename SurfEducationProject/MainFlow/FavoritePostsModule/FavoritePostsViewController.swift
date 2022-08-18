
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

    private let numberOfRows = 3

    //MARK: - Views
    private let tableView = UITableView()

    //MARK: - Singleton instances
    private let postModel: AllPostsModel = AllPostsModel.shared

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        tableView.reloadData()
    }
}
//MARK: - Private methods
private extension FavoritePostsViewController {
    func configureAppearance() {
        configureTableView()
    }

    func configureNavigationBar() {
        navigationItem.title = "Favorites"
        let searchButton = UIBarButtonItem(image: UIImage(image: searchBar),
                style: .plain,
                target: self,
                action: #selector(goToSearchVC(sender:)))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = ColorsStorage.black
    }
    func configureModel() {
        postModel.didPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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
        tableView.register(UINib(nibName: "\(DetailPostsImagesTableViewCell.self)", bundle: .main), forCellReuseIdentifier: "\(DetailPostsImageTableViewCell.self)")
        tableView.register(UINib(nibName: "\(DetailPostsTitlesTableViewCell.self)", bundle: .main), forCellReuseIdentifier: "\(DetailPostsTitleTableViewCell.self)")
        tableView.register(UINib(nibName: "\(DetailPostsBodiesShortedTableViewCell.self)", bundle: .main), forCellReuseIdentifier: "\(DetailPostsBodiesShortedTableViewCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    @objc func goToSearchVC(sender: UIBarButtonItem) {
        let vc = SearchPostsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
                    let alert = UIAlertController(title: "Attention", message: "Are you sure you want to delete from favorites?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Yes, exactly", style: UIAlertAction.Style.default, handler: { action in
                        let favoritesStorage: FavoritesStorage = FavoritesStorage.shared

                        if favoritesStorage.isPostFavorite(post: currentPost.title) {
                            favoritesStorage.removeFavorite(favoritePost: currentPost.title)
                        } else {
                            favoritesStorage.addFavorite(favoritePost: currentPost.title)
                        }
                        cell.isFavorite.toggle()
                        if let favoritePost = self?.postModel.favoritePosts[indexPath.section] {
                            self?.postModel.favoritePost(for: favoritePost)
                            self?.tableView.reloadData()
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)


                }
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailPostsTitlesTableViewCell.self)")
            if let cell = cell as? DetailedPostTitleTableViewCell {
                cell.titleText = postModel.favoritePosts[indexPath.section].title
                cell.titleDate = postModel.favoritePosts[indexPath.section].dateCreation
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailPostsBodiesShortedTableViewCell.self)")
            if let cell = cell as? DetailedPostBodyShortedTableViewCell {
                cell.bodyText = postModel.favoritePosts[indexPath.section].content
            }
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailedPostsViewController()
        vc.model = self.postModel.favoritePosts[indexPath.section]
        navigationController?.pushViewController(vc, animated: true)
    }
}

