
//
//  DetailPostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 07.08.2022.
//
import UIKit

class DetailPostViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: Constants
    private let backArrowImage: UIImage? = ImagesStorage.backArrow

    private let detailPostsImagesTableViewCell: String = "\(DetailPostsImagesTableViewCell.self)"
    private let detailPostsTitlesTableViewCell: String = "\(DetailPostsTitlesTableViewCell.self)"
    private let detailPostsBodiesTableViewCell: String = "\(DetailPostsBodiesTableViewCell.self)"

    private let numberOfRows = 3
    //MARK: - Views
    private let tableView = UITableView()
    //MARK: - Properties
    var model: PostModel?

    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}
//MARK: - Private methods
private extension DetailedPostViewController {
    func configureAppearance() {
        configureTableView()
    }

    func configureNavigationBar() {
        navigationItem.title = model?.title ?? ""
        let backButton = UIBarButtonItem(image: backArrowImage,
                style: .plain,
                target: navigationController,
                action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = ColorsStorage.black
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
        tableView.register(UINib(nibName: detailPostsBodiesTableViewCell, bundle: .main), forCellReuseIdentifier: detailPostsBodiesTableViewCell)
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}
//MARK: - TableView DataSource
extension DetailedPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            if let cell = cell as? DetailedPostsImagesTableViewCell {
                cell.imageUrlInString = model?.imageUrlInString ?? ""
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailPostsTitlesTableViewCell)
            if let cell = cell as? DetailPostsTitlesTableViewCell {
                cell.titlesPostsText.text = model?.title ?? ""
                cell.titlesPostsDate.text = model?.dateCreation ?? ""
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailPostsBodiesTableViewCell)
            if let cell = cell as? DetailPostsBodiesTableViewCell {
                cell.postsBodiesText.text = model?.content ?? ""
            }
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }


}