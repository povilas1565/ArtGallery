//
//  ContactsCell.swift
//  SurfSummerSchoolProject
//
// Created by Павел Рыжков on 17.08.2022.
//

import UIKit

class ContactsCell: UITableViewCell {
    @IBOutlet weak var contactTypeLabel: UILabel!
    @IBOutlet weak var contactDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
