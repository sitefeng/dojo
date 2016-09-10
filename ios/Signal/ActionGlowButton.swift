//
//  ActionGlowButton.swift
//  Signal
//
//  Created by Si Te Feng on 9/10/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit

class ActionGlowButton: UIButton {
    
    override var enabled: Bool {
        didSet(isEnabled) {
            if isEnabled {
                self.titleLabel?.textColor = UIColor.whiteColor()
            } else {
                self.titleLabel?.textColor = UIColor.defaultGreenColor()
            }
        }
    }
    
    func setupButtonWithTitle(title: String) {
        
        let backgroundImage = UIImage(named: "mainButtonColor")
        self.setBackgroundImage(backgroundImage, forState: UIControlState.Normal)
        
        let disabledImage = UIImage(named: "disabledButtonColor")
        self.setBackgroundImage(disabledImage, forState: UIControlState.Disabled)
        
        var cornerRadius: CGFloat = self.frame.height / 2.0
        if (self.frame.height > CGFloat(0)) {
            cornerRadius = self.frame.height / 2.0
        } else {
            cornerRadius = 22
        }
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.defaultGreenColor().CGColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 15
    }

    

}
