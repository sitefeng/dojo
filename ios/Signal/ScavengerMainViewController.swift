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
    
    var selectedLanguageCode = "fr"
    
    // 2D Array
    var wordsForLevelControllers = [["Leather", "Fork", "Technology"], ["Money", "Drink", "Fork"], ["Shoe", "Keyboard", "Flower", "Ship"]]
    var translatedWordsForLevelControllers: [[String]] = [[],[],[]]
    var wordsCompletedForLevelControllers = [[false, false, false], [false, false, false], [false, false, false, false]]
    
    convenience init(languageCode: String) {
        self.init(nibName: "ScavengerMainViewController", bundle: nil)
        
        selectedLanguageCode = languageCode
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedLanguageCode = SignalAppGlobals.sharedInstance.userLanguage()
        
        primaryLabel.text = "Scavenger Hunt (\(selectedLanguageCode.capitalizedString))"
        
        transluscentView.backgroundColor = UIColor.transluscentWhite()
        transluscentView.clipsToBounds = true
        headerImageView.clipsToBounds = true
        
        // Loading view controllers inside scrollView
        controllerScrollView.showsHorizontalScrollIndicator = false
        controllerScrollView.showsVerticalScrollIndicator = false
        controllerScrollView.pagingEnabled = true
        controllerScrollView.alwaysBounceVertical = false
        
        let request = NetworkRequests()
        var index = 0
        for wordArray in wordsForLevelControllers {
            
            request.translate(wordArray, index: index, completionBlock: { (success, i, translatedWords) in
                guard success else {
                    print("error")
                    return
                }
                self.translatedWordsForLevelControllers[i] = translatedWords
                
                // Load Content
                self.reloadSubViewControllers()
            })
            
            index += 1
        }
        
    }
    
    
    func reloadSubViewControllers() {
        
        // Removing all from before
        for levelController in levelViewControllers {
            levelController.willMoveToParentViewController(nil)
            levelController.view.removeFromSuperview()
            levelController.removeFromParentViewController()
        }
        levelViewControllers = []
        
        
        // Readding
        let screenWidth = UIScreen.mainScreen().bounds.width
        let levelHeight = UIScreen.mainScreen().bounds.height - 128

        var index = 0
        for wordsForLevel in translatedWordsForLevelControllers {
            
            let levelHuntViewController = ScavengerHuntViewController(wordsForLevel: wordsForLevel, englishTranslations: wordsForLevelControllers[index],  levelValue: index + 1)
            levelHuntViewController.view.frame = CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: levelHeight)
            levelHuntViewController.view.layer.shadowColor = UIColor.blackColor().CGColor
            levelHuntViewController.view.layer.shadowOpacity = 0.5
            
            levelViewControllers.append(levelHuntViewController)
            self.addChildViewController(levelHuntViewController)
            
            controllerScrollView.addSubview(levelHuntViewController.view)
            levelHuntViewController.didMoveToParentViewController(self)
            
            index += 1
        }
        
        controllerScrollView.contentSize = CGSize(width: CGFloat(index) * screenWidth, height: levelHeight)
    }
    

    @IBAction func returnButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
