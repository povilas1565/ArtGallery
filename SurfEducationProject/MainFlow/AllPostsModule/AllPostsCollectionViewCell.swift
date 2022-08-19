//
//  AllPostsCollectionViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 06.08.2022.
//
import UIKit

class AllPostsCollectionViewCell: UICollectionViewCell {

    //MARK: - Constants

    private enum Constants {
        static let favoriteTapped = UIImage(named: "favoriteTapped")
        static let favoriteUntapped = UIImage(named: "favoriteUntapped")
    }
    let favoritesStorage = FavoritesStorage.shared

    //MARK: - Views

    @IBOutlet private weak var postsImageView: UIImageView!
    @IBOutlet private weak var favoritePostsButtonLabel: UIButton!
    @IBOutlet weak var postTextLabel: UILabel!


    //MARK: - Events
    var didFavoriteTap: (() -> Void)?

    //MARK: - Calculated
    var buttonImage: UIImage? {
        return isFavorite ? Constants.favoriteTapped : Constants.favoriteUntapped
    }
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.contentView.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            }
        }
    }

    //MARK: - Properties
    var titlesTexts: String = "" {
        didSet {
            postsTextLabel.text = titlesText
        }
    }

    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                return
            }
            postsImageView.loadImage(from: url)
        }
    }

    var isFavorite = false {
        didSet {
            favoritePostsButtonLabel.setImage(buttonImage, for: .normal)
        }
    }

    //MARK: - Action

    @IBAction func favoritePostsButtonAction(_ sender: UIButton) {
        didFavoriteTap?()
        if favoritesStorage.isPostsFavorite(post: self.postTextLabel.text ?? "") {
            favoritesStorage.removeFavorite(favoritePost: self.postTextLabel.text ?? "")
        } else {
            favoritesStorage.addFavorite(favoritePost: self.postTextLabel.text ?? "")
        }
        isFavorite.toggle()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    override func prepareForReuse() {
        imageUrlInString = ""
        titlesText = ""
        postsImageView.image = UIImage()

    }
}

//MARK: - Private methods
private extension AllPostsCollectionViewCell {
    func configureCell() {
        postsTextLabel.textColor = .black
        postsTextLabel.font = .systemFont(ofSize: 12)

        postsImageView.layer.cornerRadius = 12

        favoritePostsButtonLabel.tintColor = .white
        isFavorite = false
    }
    }