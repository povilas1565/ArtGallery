
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
    @IBOutlet weak var titlesPostsDate: UILabel!


    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    private func configureAppearance() {
        selectionStyle = .none
        titlePostTexts.font = .systemFont(ofSize: 16)
        titlePostDates.font = .systemFont(ofSize: 10)
        titlePostDates.textColor = ColorsStorage.lightGray
    }

}
