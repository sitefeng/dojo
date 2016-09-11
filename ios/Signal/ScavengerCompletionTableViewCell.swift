//
//  ScavengerCompletionTableViewCell.swift
//  Signal
//
//  Created by Si Te Feng on 9/10/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit

final internal class ScavengerCompletionTableViewCell: UITableViewCell {

    static let CellHeight = CGFloat(69.5)
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customImageView.layer.cornerRadius = customImageView.frame.size.height / 2.0
        customImageView.layer.masksToBounds = true
        
    }

    func setupCell(mainText: String, secondaryText: String) {
        mainLabel.text = mainText
        secondaryLabel.text = secondaryText
    }
    
}
