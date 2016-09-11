//
//  ViewController.swift
//  Signal
//
//  Created by Si Te Feng on 9/9/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var loginButton: ActionGlowButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let languagesAvailable =  ["English":"en", "Chinese":"zh", "French":"fr", "German":"de", "Italian":"it", "Spanish":"es", "Greek":"el", "Japanese":"ja", "Korean":"ko", "Latin":"la", "Persian":"fa", "Russian":"ru", "Hindi":"hi"]
    var sortedKeys = []
    
    private(set) var selectedLanguage = "French"
    var selectedCode: String {
        return languagesAvailable[selectedLanguage] ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortedKeys = Array(languagesAvailable.keys)

        sortedKeys = sortedKeys.sort { (obj1, obj2) -> Bool in
            return (obj1 as! String) < (obj2 as! String)
        }
        
        loginButton.setupButtonWithTitle("Start")
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languagesAvailable.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortedKeys[row] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguage = sortedKeys[row] as! String
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let vc = ScavengerMainViewController(nibName: "ScavengerMainViewController", bundle: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }

}

