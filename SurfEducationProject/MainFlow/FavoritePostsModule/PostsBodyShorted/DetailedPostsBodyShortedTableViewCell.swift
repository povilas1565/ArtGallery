//
//  DetailedPostBodyShortedTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 07.08.2022.
//
import UIKit

class DetailedPostsBodyShortedTableViewCell: UITableViewCell {
//MARK: - Views
    @IBOutlet weak var bodyTextShorted: UILabel!
    //MARK: - Properties
    var bodyText: String = "" {
        didSet {
            bodyTextShorted.text = bodyText
        }
    }
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureApperance()
    }
    private func configureApperance() {
        selectionStyle = .none
        bodyTextShorted.font = .systemFont(ofSize: 15, weight: .light)
        bodyTextShorted.textColor = .black
    }

}