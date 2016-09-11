//
//  ScavengerHuntViewController.swift
//  Signal
//
//  Created by Si Te Feng on 9/10/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit

final internal class ScavengerHuntViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private let kCellReuseIdentifier = "kCellReuseIdentifier"
    
    private let itemWidth = CGFloat(240)
    private let itemHeight = CGFloat(70)
    
    @IBOutlet weak var dashletBackgroundView: UIView!
    @IBOutlet weak var mainDashletLabel: UILabel!
    @IBOutlet weak var secondaryDashletLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var continueButton: ActionGlowButton!
    
    
    var listOfWords: [String] = []
    var englishWords: [String] = []
    
    var level: NSInteger = 0
    
    var requiredWordCount: NSInteger {
        get {
            return NSInteger(floor(Double(listOfWords.count) / 3.0 * 2))
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        assert(false, "not implemented")
        super.init(coder: aDecoder)
    }
    
    convenience init(wordsForLevel: [String], englishTranslations: [String], levelValue: NSInteger) {
        self.init(nibName: "ScavengerHuntViewController", bundle: nil)
        level = levelValue
        listOfWords = wordsForLevel
        englishWords = englishTranslations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashletBackgroundView.backgroundColor = UIColor.whiteColor()
        dashletBackgroundView.layer.cornerRadius = 6
        dashletBackgroundView.layer.masksToBounds = true
        dashletBackgroundView.layer.shadowColor = UIColor.blackColor().CGColor
        dashletBackgroundView.layer.shadowOpacity = 0.5
        
        mainDashletLabel.text = "Level \(level)"
        secondaryDashletLabel.text = "Find \(requiredWordCount) out of the \(listOfWords.count) items to continue."
        
        continueButton.setupButtonWithTitle("Continue")
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.minimumInteritemSpacing = 30
        flowLayout.minimumLineSpacing = 8
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.registerNib( UINib(nibName: "ScavengerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellReuseIdentifier)
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(scavengerCompleted), name: SignalConstants.SignalScavengerCompletedNotification, object: nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK - NSNotification 
    func scavengerCompleted() {
        self.collectionView.reloadData()
    }
    
    // MARK - Collection View

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfWords.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(kCellReuseIdentifier, forIndexPath: indexPath) as! ScavengerCollectionViewCell
        
        cell.cellTitle = listOfWords[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let scavengerCaptureViewController = ScavengerCaptureViewController(scavengerWord: listOfWords[indexPath.row], wordInEnglish: englishWords[indexPath.row])
        self.presentViewController(scavengerCaptureViewController, animated: true, completion: nil)
        
    }
    
    
    
}
