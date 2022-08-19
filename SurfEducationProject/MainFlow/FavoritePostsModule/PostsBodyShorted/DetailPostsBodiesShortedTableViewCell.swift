//
//  DetailedPostBodyShortedTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 07.08.2022.
//
import UIKit

class DetailPostsBodiesShortedTableViewCell: UITableViewCell {
//MARK: - Views
    @IBOutlet weak var bodyTextShorted: UILabel!

    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }
    private func configureAppearance() {
        selectionStyle = .none
        bodyTextShorted.font = .systemFont(ofSize: 12, weight: .light)
        bodyTextShorted.textColor = .black
    }

}