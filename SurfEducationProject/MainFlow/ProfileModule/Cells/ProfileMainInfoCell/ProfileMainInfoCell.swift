//
//  ProfileMainInfoCell.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 17.08.2022.
//
import UIKit

class ProfileMainInfoCell: UITableViewCell {
    //MARK: - Views
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileFirstNameLabel: UILabel!
    @IBOutlet private weak var profileLastNameLabel: UILabel!
    @IBOutlet private weak var profileQuoteLabel: UILabel!

    //MARK: - Properties
    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                return
            }
            profileImageView.loadImage(from: url)
        }
    }

    //MARK: - Cell's lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        profileImageView.layer.cornerRadius = 12
    }
}
