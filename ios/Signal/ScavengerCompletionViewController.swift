//
//  ScavengerCompletionViewController.swift
//  Signal
//
//  Created by Si Te Feng on 9/10/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit

class ScavengerCompletionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let kCellReuseIdentifier = "kCellReuseIdentifier"
    
    var lookupMode: Bool = false
    
    private var scavengerImage: UIImage?
    private var correctness: Bool = false
    private var associationItems: [AssociationItem]!
    private var scavengerName: String = ""
    private var englishName: String = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var correctnessImageView: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    @IBOutlet weak var relatedTableView: UITableView!
    @IBOutlet weak var backButton: ActionGlowButton!
    
    /// itemName is in foreign language
    /// for scavenger mode only
    convenience init(capturedImage: UIImage, guessCorrectness: Bool, associations: [AssociationItem], itemName: String) {
        self.init(nibName: "ScavengerCompletionViewController", bundle: nil)
        
        lookupMode = false
        
        scavengerImage = capturedImage
        correctness = guessCorrectness
        associationItems = associations
        scavengerName = itemName
    }
    
    /// for lookupMode only
    convenience init(capturedImage: UIImage, associations: [AssociationItem], itemName: String) {
        self.init(nibName: "ScavengerCompletionViewController", bundle: nil)
        
        lookupMode = true
        
        // set correctness to always true for free lookup mode
        correctness = true
        
        scavengerImage = capturedImage
        associationItems = associations
        scavengerName = itemName
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Requesting for server data
        let request = NetworkRequests()
        request.translate([scavengerName], index: 0, destinationLanguage: SignalConstants.AppDefaultLanguageCode) { (success, _, translatedWords) in
            
            self.englishName = translatedWords.first ?? ""
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                self.secondaryLabel.text = self.englishName
            })
        }

        // Initializing and customizing views
        imageView.image = scavengerImage
        imageView.layer.cornerRadius = imageView.frame.size.height / 2.0
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 6
        
        if lookupMode == false {
            if correctness {
                correctnessImageView.image = UIImage(named: "correct")
            } else {
                correctnessImageView.image = UIImage(named: "wrong")
            }
        } else {
            correctnessImageView.image = nil
        }
        
        whiteView.layer.cornerRadius = 10
        whiteView.layer.masksToBounds = true
        whiteView.layer.shadowColor = UIColor.blackColor().CGColor
        whiteView.layer.shadowOpacity = 0.5
        
        mainLabel.text = scavengerName
        
        relatedTableView.registerNib(UINib(nibName: "ScavengerCompletionTableViewCell", bundle: nil) , forCellReuseIdentifier: kCellReuseIdentifier)
        relatedTableView.dataSource = self
        relatedTableView.delegate = self
        
        if correctness {
            backButton.setupButtonWithTitle("BACK TO HUNT")
        } else {
            backButton.setupButtonWithTitle("TRY AGAIN")
        }
    }
    
    // MARK: Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return associationItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = relatedTableView.dequeueReusableCellWithIdentifier(kCellReuseIdentifier, forIndexPath: indexPath) as! ScavengerCompletionTableViewCell
        
        let associationItem = associationItems[indexPath.row]
        cell.setupCell(associationItem.translation, secondaryText: associationItem.name, imageURL: associationItem.imageURL)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ScavengerCompletionTableViewCell.CellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
            
            if self.correctness == true {
                NSNotificationCenter.defaultCenter().postNotificationName(SignalConstants.SignalScavengerCompletedNotification, object: self)
            }
        }
        
    }
    
}
