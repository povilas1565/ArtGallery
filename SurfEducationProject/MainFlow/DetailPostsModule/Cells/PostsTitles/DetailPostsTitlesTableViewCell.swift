
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

    private func configureApperance() {
        selectionStyle = .none
        titlePostTexts.font = .systemFont(ofSize: 16)
        titlePostDates.font = .systemFont(ofSize: 10)
        titlePostDates.textColor = UIColor(displayP3Red: 0xB3 / 255, green: 0xB3 / 255, blue: 0xB3 / 255, alpha: 1)
    }

}
