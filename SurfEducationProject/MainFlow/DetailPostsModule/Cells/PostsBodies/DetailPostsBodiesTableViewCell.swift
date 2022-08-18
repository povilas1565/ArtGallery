
//
//  DetailPostsBodiesTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 07.08.2022.
//
import UIKit

class DetailPostsBodiesTableViewCell: UITableViewCell {

    //MARK: - Views
    @IBOutlet weak var postsBodiesText: UILabel!

    //MARK: - Properties
    var bodiesText: String = "" {
        didSet {
            postBodiesText.text = bodiesText
        }
    }

    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureApperance()
    }

    private func configureAppearance() {
        selectionStyle = .none
        postBodiesText.font = .systemFont(ofSize: 12, weight: .light)
        postBodiesText.textColor = .black
    }

}