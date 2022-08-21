//
//  AllPostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 05.08.2022.
//
import UIKit

class AllPostsViewController: UIViewController {

    //MARK: - Constants

    private enum Constants {
        static let collectionViewPadding: CGFloat = 16
        static let hSpaceBetweenItems: CGFloat = 7
        static let vSpaceBetweenItems: CGFloat = 8
    }

    private enum ConstantImages {
        static let searchBar: UIImage? = ImageStorage.searchBar
        static let sadSmile: UIImage? = ImageStorage.sadSmile

    }
    private let fetchPostsErrorVC = PostsLoadErrorViewController()
    private let cellProportion: Double = 246/168
    private let allPostsCollectionViewCell: String = "\(AllPostsCollectionViewCell.self)"

    //MARK: - Private properties
    private let postModel = AllPostsModel.shared

    //MARK: - Public properties
    static var favoriteTapStatus: Bool = false

    //MARK: - Views
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var allPostsCollectionView: UICollectionView!
    @IBOutlet private weak var emptyPostsNotificationImage: UIImageView!
    @IBOutlet private weak var emptyPostsNotificationLabel: UILabel!
    @IBOutlet private weak var zeroScreenButtonLabel: UIButton!
    private let refreshControl = UIRefreshControl()

    //MARK: - Actions
    @IBAction func zeroScreenButtonAction(_ sender: Any) {
        postModel.loadPosts()
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        postModel.loadPosts()
        configureAppearance()
        configureModel()
        configurePullToRefresh()
        configureZeroStateButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AllPostsViewController.favoriteTapStatus {
            allPostsCollectionView.reloadData()
            AllPostsViewController.favoriteTapStatus = false
        }
        appendStateViewController {
            self.postModel.loadPosts()
            self.fetchPostsErrorVC.view.alpha = 0
            self.activityIndicatorView.isHidden = false
        }

        if postModel.currentState == .error && postModel.posts.isEmpty {
            fetchPostsErrorVC.view.alpha = 1
            configureModel()
        }

        configureNavigationBar()
    }
}

//MARK: - Private methods
private extension AllPostsViewController {
    func configureAppearance() {
        allPostsCollectionView.register(UINib(nibName: allPostsCollectionViewCell, bundle: .main), forCellWithReuseIdentifier: allPostsCollectionViewCell)
        allPostsCollectionView.dataSource = self
        allPostsCollectionView.delegate = self
        allPostsCollectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
    }
    func configureNavigationBar() {
        navigationItem.title = "Main"
        let searchButton = UIBarButtonItem(image: ConstantImages.searchBar,
                style: .plain,
                target: self,
                action: #selector(goToSearchVC(sender:)))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = ColorsStorage.black
    }

    func configureModel() {
        postModel.didPostsFetchErrorHappened = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                if self.postModel.posts.isEmpty {
                    self.nonEmptyPostListNotification()
                    self.activityIndicatorView.isHidden = true
                    self.fetchPostsErrorVC.view.alpha = 1
                    //Ниже обработка кейса, когда токен обнулили на сервере, но в приложении время его действия не вышло. Пусть будет, иначе возможно зацикливание приложения, которому даже удаление не поможет. Т.к. токен лежит в keyChain.
                    if AllPostsModel.errorDescription == "Token is not valid" {
                        if let delegate = UIApplication.shared.delegate as? AppDelegate {
                            let authViewController = AuthViewController()
                            let navigationAuthViewController = UINavigationController(rootViewController: authViewController)
                            delegate.window?.rootViewController = navigationAuthViewController
                        }
                    }
                } else {
                    let textForSnackBar = AllPostsModel.errorDescription
                    let model = SnackbarModel(text: textForSnackBar)
                    let snackbar = SnackbarView(model: model, viewController: self)
                    snackbar.showSnackBar()
                }
            }
        }

        postModel.didPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.activityIndicatorView.isHidden = true
                self.allPostsCollectionView.reloadData()
                FavoritePostsViewController.successLoadingPostsAfterZeroScreen = true
                self.postModel.posts.isEmpty ? self.emptyPostListNotification() : self.nonEmptyPostListNotification()
            }
        }
    }

    func configurePullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = ColorsStorage.lightGray
        refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        allPostsCollectionView.addSubview(refreshControl)

        }

    @objc func goToSearchVC(sender: UIBarButtonItem) {
        let vc = SearchPostsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func pullToRefresh(_ sender: AnyObject) {
        self.postModel.loadPosts()
        refreshControl.endRefreshing()
    }

    func configureZeroStateButton() {
        zeroScreenButtonLabel.titleLabel?.text = "Update data"
        zeroScreenButtonLabel.backgroundColor = ColorsStorage.black
        zeroScreenButtonLabel.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        zeroScreenButtonLabel.isHidden = true
    }

    func appendStateViewController(refreshButtonAction: @escaping ()->Void) {
        fetchPostsErrorVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(fetchPostsErrorVC)
        self.view.addSubview(fetchPostsErrorVC.view)
        fetchPostsErrorVC.didMove(toParent: self)

        fetchPostsErrorVC.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fetchPostsErrorVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        fetchPostsErrorVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        fetchPostsErrorVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        fetchPostsErrorVC.view.alpha = 0
        fetchPostsErrorVC.refreshButtonAction = refreshButtonAction
    }

    func emptyPostListNotification() {
        configureZeroStateButton()
        zeroScreenButtonLabel.isHidden = false
        emptyPostsNotificationImage.image = ConstantImages.sadSmile
        emptyPostsNotificationLabel.font = .systemFont(ofSize: 14, weight: .light)
        emptyPostsNotificationLabel.text = "The posts are empty"
        view.bringSubviewToFront(emptyPostsNotificationImage)
        view.bringSubviewToFront(emptyPostsNotificationLabel)
        view.bringSubviewToFront(zeroScreenButtonLabel)
    }

    func nonEmptyPostListNotification() {
        zeroScreenButtonLabel.isHidden = true
        emptyPostsNotificationImage.image = UIImage()
        emptyPostsNotificationLabel.text = ""
    }

}

//MARK: - UICollection
extension AllPostsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postModel.posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = allPostsCollectionView.dequeueReusableCell(withReuseIdentifier: "\(AllPostsCollectionViewCell.self)", for: indexPath)
        if let cell = cell as? AllPostsCollectionViewCell {
            self.activityIndicatorView.isHidden = true
            cell.poststitlesText = postModel.posts[indexPath.item].title
            cell.isFavorite = postModel.posts[indexPath.item].isFavorite
            cell.imageUrlInString = postModel.posts[indexPath.item].imageUrlInString
            cell.didFavoriteTap = { [weak self] in
                self?.postModel.posts[indexPath.item].isFavorite.toggle()
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (view.frame.width - Constants.collectionViewPadding * 2 - Constants.hSpaceBetweenItems) / 2
        return CGSize(width: itemWidth, height: itemWidth * cellProportion)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ConstantConstraints.vSpaceBetweenItems
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ConstantConstraints.hSpaceBetweenItems
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPostsViewController()
        vc.model = self.postModel.posts[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}