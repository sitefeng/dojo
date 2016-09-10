//
//  ViewController.swift
//  Signal
//
//  Created by Si Te Feng on 9/9/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit
import performSelector_swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    @IBAction func buttonTapped(sender: AnyObject) {
        
        let vc = ScavengerMainViewController(nibName: "ScavengerMainViewController", bundle: nil)
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    
    

}

