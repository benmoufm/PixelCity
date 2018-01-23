//
//  PopViewController.swift
//  PixelCity
//
//  Created by Mélodie Benmouffek on 23/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class PopViewController: UIViewController {

    // Outlets
    @IBOutlet weak var popImageView: UIImageView!

    // Variables
    var passedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        popImageView.image = passedImage
    }

    func initData(forImage passedImage: UIImage) {
        self.passedImage = passedImage
    }
}
