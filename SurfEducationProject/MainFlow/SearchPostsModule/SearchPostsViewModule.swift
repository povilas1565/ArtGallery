
//
//  SearchPostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 08.08.2022.
//
import UIKit

class SearchPostsViewController: UIViewController, UIGestureRecognizerDelegate {

    //MARK: - Constants
    private enum Constants {
        static let collectionViewPadding: CGFloat = 16
        static let hSpaceBetweenItems: CGFloat = 7
        static let vSpaceBetweenItems: CGFloat = 8
    }

    //MARK: - Views

    @IBOutlet private weak var searchUserNotificationsImages: UIImageView!
    @IBOutlet private weak var searchUserNotificationsTexts: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 303, height: 32))

    //MARK: - Properties
    var notifyImages: UIImages? {
        didSet {
            searchUserNotificationsImages.images = notifyImages
        }
    }
    var notifyTexts: String = "" {
        didSet {
            searchUserNotificationTexts.texts = notifyTexts
        }
    }
    var posts = AllPostsModel.shared.filteredPosts(searchText: "")

    //MARK: - Methods
    func configureApperance() {
        searchUserNotificationsTexts.font = .systemFont(ofSize: 17, weight: .light)
        notifyImage = UIImage(named: "searchLens")
        searchUserNotificationsTexts.texts = "Enter your request"
        searchBar.delegate = self
        collectionView.register(UINib(nibName: "\(AllPostsCollectionViewCell.self)", bundle: .main), forCellWithReuseIdentifier: "\(AllPostsCollectionViewCell.self)")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
    }
    //TO DO: пока что не работает
//    @objc func resignSearchBar() {
//        //searchBar.resignFirstResponder()
//        self.searchBar.endEditing(true)
//    }

    func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "backArrow"),
                style: .plain,
                target: navigationController,
                action: #selector(UINavigationController.popViewController(animated:)))
        let searchBarItem = UIBarButtonItem(customView: searchBar)
        navigationItem.rightBarButtonItem = searchBarItem
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
}

//MARK: - Search delegate
extension SearchPostsViewsController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchBar.resignFirstResponder()
        if !searchText.isEmpty {
            posts = AllPostsModel.shared.filteredPosts(searchText: searchBar.text ?? "")
            notifyImage = UIImage()
            searchUserNotificationText.text = ""
            if posts.isEmpty {
                notifyImage = UIImage(named: "sadSmile")
                searchUserNotificationsTexts.texts = "There are no results for this query, try another query"
                collectionView.reloadData()
            } else {
                collectionView.reloadData()
            }
        } else {
            posts = []
            collectionView.reloadData()
            notifyImage = UIImage(named: "searchLens")
            searchUserNotificationText.text = "Введите ваш запрос"
        }
    }
}

extension SearchPostsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AllPostsCollectionViewCell.self)", for: indexPath)
        if let cell = cell as? AllPostsCollectionViewCell {
            cell.titlesTexts = posts[indexPath.item].title
            cell.isFavorite = posts[indexPath.item].isFavorite
            cell.imageUrlInString = posts[indexPath.item].imageUrlInString
            cell.didFavoriteTap = { [weak self] in
                self?.posts[indexPath.item].isFavorite.toggle()
                AllPostsModel.shared.favoritePost(for: self?.posts[indexPath.item] ?? PostModel.createDefault())
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (view.frame.width - Constants.collectionViewPadding * 2 - Constants.hSpaceBetweenItems) / 2
        return CGSize(width: itemWidth, height: itemWidth / 168 * 246)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.vSpaceBetweenItems
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.hSpaceBetweenItems
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPostsViewController()
        vc.model = posts[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}
