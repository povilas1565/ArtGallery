
//
//  DetailPostsTitlesTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 06.08.2022.
//
import UIKit

class DetailedPostsTitlesTableViewCell: UITableViewCell {
    //MARK: - Views


    @IBOutlet weak var titlesPostsText: UILabel!
    @IBOutlet private weak var titlesPostsDate: UILabel!

    //MARK: - Properties
    var titlesText: String = "" {
        didSet {
            titlePostsText.text = titlesText
        }
    }
    var titlesDates: String = "" {
        didSet {
            titlePostsDate.text = titlesDate
        }
    }

    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureApperance()
    }

    private func configureAppearance() {
        selectionStyle = .none
        titlePostTexts.font = .systemFont(ofSize: 16)
        titlePostDates.font = .systemFont(ofSize: 10)
        titlePostDates.textColor = ColorsStorage.lightGray
    }

}
