//
//  PostsLoadErrorViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 09.08.2022.
//
import UIKit

class PostsLoadErrorViewController: UIViewController {

    var refreshButtonAction: ()->Void = {}

    @IBAction func refreshButton(_ sender: Any) {
        refreshButtonAction()
        self.view.alpha = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}