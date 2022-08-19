//
//  AlertView.swift
//  SurfSummerSchoolProject
//
// Created by Павел Рыжков on 19.08.2022.
//

import UIKit

func appendConfirmingAlertView(for viewController: UIViewController, text: String, completion: @escaping (UIAlertAction) -> Void) {
    let alert = UIAlertController(title: "Attention", message: text, preferredStyle: UIAlertController.Style.alert)
    let confirmAction = UIAlertAction(title: "Yes, exactly", style: UIAlertAction.Style.default, handler: completion)
    let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    alert.preferredAction = confirmAction

    viewController.present(alert, animated: true, completion: nil)
}