//
//  AssociationItem.swift
//  Signal
//
//  Created by Si Te Feng on 9/11/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit

final internal class AssociationItem: NSObject {

    var name: String = ""
    var imageURL: NSURL = NSURL()
    var translation: String = ""
    
    convenience init(rawDictionary: [String: AnyObject]) {
        self.init()
        self.name = rawDictionary["name"] as! String
        
        let imageURLPath = rawDictionary["url"] as! String
        guard let url = NSURL(string: imageURLPath) else {
            print("Error: url is nil")
            return
        }
        
        imageURL = url
        
        self.translation = rawDictionary["translation"] as! String
    }
    
    override init() {
        super.init()
    }
}
