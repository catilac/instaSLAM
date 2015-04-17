//
//  PhotosDetailViewController.swift
//  instaSLAM
//
//  Created by Chirag Dave on 4/16/15.
//  Copyright (c) 2015 Chirag Davé. All rights reserved.
//

import UIKit

class PhotosDetailViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    
    weak var photoSource: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photo.image = photoSource
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
