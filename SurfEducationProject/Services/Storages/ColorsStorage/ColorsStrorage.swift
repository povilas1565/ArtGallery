//
//  ColorsStorage.swift
//  SurfSummerSchoolProject
//
// Created by Павел Рыжков on 15.08.2022.
//

import UIKit

class ColorsStorage {
    static let white = UIColor(rgb: 0xFFFFFF)
    static let black = UIColor(rgb: 0x000000)
    static let red = UIColor(rgb: 0xF35858)
    static let lightGray = UIColor(rgb: 0xB0B0B0)
    static let lightBackgroundGray = UIColor(rgb: 0xFBFBFB)
    static let lightTextGray = UIColor(rgb: 0xDFDFDF)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
                red: (rgb >> 16) & 0xFF,
                green: (rgb >> 8) & 0xFF,
                blue: rgb & 0xFF
        )
    }
}


