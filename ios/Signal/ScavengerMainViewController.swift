//
//  ScavengerMainViewController.swift
//  Signal
//
//  Created by Si Te Feng on 9/10/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit

class ScavengerMainViewController: UIViewController {

    @IBOutlet weak var controllerScrollView: UIScrollView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var transluscentView: UIView! // to cover a veil on top of headerImageView
    
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var primaryLabel: UILabel!
    
    var levelViewControllers: [ScavengerHuntViewController] = []
    
    // 2D Array
    var wordsForLevelControllers = [["Trump", "Lanyard", "Vent", "Chair"], ["Vent", "Chair", "Flower", "Ship"], ["Trump", "Lanyard", "Vent", "Chair", "Flower", "Ship"]]
    var wordsCompletedForLevelControllers = [[false, false, false, false], [false, false, false, false], [false, false, false, false, false, false]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let levelHeight = UIScreen.mainScreen().bounds.height - 128
        
        transluscentView.backgroundColor = UIColor.transluscentWhite()
        transluscentView.clipsToBounds = true
        headerImageView.clipsToBounds = true
        
        // Loading view controllers inside scrollView
        controllerScrollView.showsHorizontalScrollIndicator = false
        controllerScrollView.showsVerticalScrollIndicator = false
        controllerScrollView.pagingEnabled = true
        controllerScrollView.alwaysBounceVertical = false
        
        var index = 0
        for wordsForLevel in wordsForLevelControllers {
            
            let levelHuntViewController = ScavengerHuntViewController(wordsForLevel: wordsForLevel, levelValue: index + 1)
            levelHuntViewController.view.frame = CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: levelHeight)
            levelViewControllers.append(levelHuntViewController)
            self.addChildViewController(levelHuntViewController)
            
            controllerScrollView.addSubview(levelHuntViewController.view)
            levelHuntViewController.didMoveToParentViewController(self)
            
            index += 1
        }
        
        controllerScrollView.contentSize = CGSize(width: CGFloat(index) * screenWidth, height: levelHeight)
    }

    

}
