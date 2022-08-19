
//
//  DetailPostsImagesTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 07.08.2022.
//
import UIKit

class DetailPostsImagesTableViewCell: UITableViewCell {

    //MARK: - Constants
    private enum Constants {
        static let favoriteTapped = UIImage(named: "favoriteTapped")
        static let favoriteUntapped = UIImage(named: "favoriteUntapped")
    }
    let favoritesStorage = FavoritesStorage.shared
    var postsTextsLabel: String = ""

    //MARK: - Views

    @IBOutlet private weak var detailPostsImagesView: UIImageView!
    @IBOutlet private weak var favoriteButtonLabel: UIButton!


    //MARK: - Events
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
            detailPostsImagesView?.loadImage(from: url)
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

    override func prepareForReuse() {
        detailPostsImagesView.image = UIImage()
    }
}
