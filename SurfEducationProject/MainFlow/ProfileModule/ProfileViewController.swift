//
//  ProfileViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Рыжков Павел on 04.08.2022.
//
import UIKit

class ProfileViewController: UIViewController {

    //MARK: - Constants
    private let profileMainInfoCell: String = "\(ProfileMainInfoCell.self)"
    private let contactsCell: String = "\(ContactsCell.self)"
    private let numberOfRows = 4
    private let mainInfoCellHeight: CGFloat = 160
    private let contactsCellHeight: CGFloat = 72

    //MARK: - Views
    @IBOutlet private weak var logoutButtonLabel: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    //MARK: - Model
    private var profileModel: ProfileModel = ProfileInstance.shared.profileModel


    //MARK: - Actions
    @IBAction func logoutButtonAction(_ sender: Any) {
        showButtonLoading()
        LogoutService()
        appendConfirmingAlertView(for: self, text: "Are you sure you want to exit the app?", completion: { action in
            let buttonActivityIndicator = ButtonActivityIndicator(button: self.logoutButtonLabel, originalButtonText: "Выйти")
            buttonActivityIndicator.showButtonLoading()
            LogoutService()
                    .performLogoutRequestAndRemoveToken() { [weak self] result in
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                                    let authViewController = AuthViewController()
                                    let navigationAuthViewController = UINavigationController(rootViewController: authViewController)
                                    delegate.window?.rootViewController = navigationAuthViewController
                                }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                buttonActivityIndicator.hideButtonLoading()
                                var textForSnackbar = "Failed to logout, try again"
                                if let currentError = error as? PossibleErrors {
                                    switch currentError {
                                    case .noNetworkConnection:
                                        textForSnackbar = "There is no internet connection\nTry again later"
                                    default:
                                        textForSnackbar = "Failed to logout, try again"
                                    }
                                }

                                let model = SnackbarModel(text: textForSnackbar)
                                let snackbar = SnackbarView(model: model)
                                guard let `self` = self else { return }
                                snackbar.showSnackBar(on: self, with: model)
                            }
                        }
                    }
        })
    }
    //MARK: - Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    //MARK: - Methods
   private func configureNavigationBar() {
        navigationItem.title = "Profile"
    }
    func configureTableView() {
        tableView.register(UINib(nibName: profileMainInfoCell, bundle: .main), forCellReuseIdentifier: profileMainInfoCell)
        tableView.register(UINib(nibName: contactsCell, bundle: .main), forCellReuseIdentifier: contactsCell)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - UITableView DataSource
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileMainInfoCell)
            if let cell = cell as? ProfileMainInfoCell {
                cell.imageUrlInString = profileModel.avatar
                cell.profileQuoteLabel.text = profileModel.about
                cell.profileFirstNameLabel.text = profileModel.firstName
                cell.profileLastNameLabel.text = profileModel.lastName
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell)
            if let cell = cell as? ContactsCell {
                cell.contactTypeLabel.text = "Country"
                cell.contactDetailLabel.text = profileModel.city
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell)
            if let cell = cell as? ContactsCell {
                cell.contactTypeLabel.text = "Telephone"
                cell.contactDetailLabel.text = profileModel.phone
            }
            return cell ?? UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell)
            if let cell = cell as? ContactsCell {
                cell.contactTypeLabel.text = "Email"
                cell.contactDetailLabel.text = profileModel.email
            }
            return cell ?? UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return mainInfoCellHeight
        default:
            return contactsCellHeight
        }
    }

}
