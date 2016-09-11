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
    
    private var scavengerImage: UIImage?
    private var scavengerData: NSData?
    private var scavengerName: String = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    @IBOutlet weak var relatedTableView: UITableView!
    @IBOutlet weak var backButton: ActionGlowButton!
    
    convenience init(capturedImage: UIImage, data: NSData, itemName: String) {
        self.init(nibName: "ScavengerCompletionViewController", bundle: nil)
        
        scavengerImage = capturedImage
        scavengerData = data
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
        
        let request = NetworkRequests()
        // Requesting for server data

        // Initializing and customizing views
        imageView.image = scavengerImage
        imageView.layer.cornerRadius = imageView.frame.size.height / 2.0
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 6
        
        whiteView.layer.cornerRadius = 10
        whiteView.layer.masksToBounds = true
        whiteView.layer.shadowColor = UIColor.blackColor().CGColor
        whiteView.layer.shadowOpacity = 0.5
        
        mainLabel.text = scavengerName
        
        relatedTableView.registerNib(UINib(nibName: "ScavengerCompletionTableViewCell", bundle: nil) , forCellReuseIdentifier: kCellReuseIdentifier)
        relatedTableView.dataSource = self
        relatedTableView.delegate = self
        
        backButton.setupButtonWithTitle("BACK TO HUNT")
    }
    
    // MARK: Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = relatedTableView.dequeueReusableCellWithIdentifier(kCellReuseIdentifier, forIndexPath: indexPath)
        
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
            NSNotificationCenter.defaultCenter().postNotificationName(SignalConstants.SignalScavengerCompletedNotification, object: self)
        }
        
    }
    
}
