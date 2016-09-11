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
    
    private var _mainText: String = ""
    private var _secondaryText: String = ""
    private var _imageURL: NSURL = NSURL()
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var asyncView: AsyncImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        asyncView.layer.cornerRadius = asyncView.frame.size.height / 2.0
        asyncView.layer.masksToBounds = true
        asyncView.imageURL = _imageURL
        
        mainLabel.text = _mainText
        secondaryLabel.text = _secondaryText
    }

    func setupCell(mainText: String, secondaryText: String, imageURL: NSURL) {
        _mainText = mainText
        mainLabel.text = _mainText
        
        _secondaryText = secondaryText
        secondaryLabel.text = _secondaryText
        
        _imageURL = imageURL
        asyncView.imageURL = _imageURL
    }
    
}
