
//
//  DetailPostsImagesTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 07.08.2022.
//
import UIKit

class DetailedPostsImagesTableViewCell: UITableViewCell {

    //MARK: - Constants
    private enum Constants {
        static let favoriteTapped = UIImage(named: "favoriteTapped")
        static let favoriteUntapped = UIImage(named: "favoriteUntapped")
    }
    let favoritesStorage = FavoritesStorage.shared
    var postsTextsLabel: String = ""

    //MARK: - Views

    @IBOutlet private weak var detailPostsImagesView: UIImageView!
    @IBOutlet weak var favoriteButtonLabel: UIButton!


    //MARK: - Events // Реализуется позже

    var didFavoriteTap: (() -> Void)?
    @IBAction func favoriteButtonAction(_ sender: Any) {
        didFavoriteTap?()
    }

    //MARK: - Calculated
    var buttonImage: UIImage? {
        return isFavorite ? Constants.favoriteTapped : Constants.favoriteUntapped
    }

    //MARK: - Properties
    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                return
            }
            detailedPostImageView?.loadImage(from: url)
        }
    }
    var isFavorite = false {
        didSet {
            favoriteButtonLabel.setImage(buttonImage, for: .normal)
        }
    }

    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        detailPostsImagesViews.layer.cornerRadius = 12
        detailPostsImagesViews.contentMode = .scaleAspectFill
    }
}