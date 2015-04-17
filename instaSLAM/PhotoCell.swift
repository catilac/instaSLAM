//
//  PhotoCell.swift
//  instaSLAM
//
//  Created by Chirag Dave on 4/16/15.
//  Copyright (c) 2015 Chirag Davé. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
