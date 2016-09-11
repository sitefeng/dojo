//
//  ScavengerCollectionViewCell.swift
//  Signal
//
//  Created by Si Te Feng on 9/10/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit

final internal class ScavengerCollectionViewCell: UICollectionViewCell {
    
    var cellTitle: String {
        set {
            nameLabel.text = newValue.capitalizedString
        } get {
            return nameLabel.text ?? ""
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = imageView.frame.height / 2.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.masksToBounds = true
    }

    
}
