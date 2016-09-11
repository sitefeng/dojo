//
//  SignalAppGlobals.swift
//  Signal
//
//  Created by Si Te Feng on 9/10/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit

internal class SignalAppGlobals: NSObject {
    
    static let sharedInstance = SignalAppGlobals()

    
    let ClarifaiClientID = "vBJvCByYTgrKgdGRujAb-NBLzBBpX7C2W_UwAr00"
    let ClarifaiClientSecret = "WNfQfXPkHPiW-pDIcPrH-e6H2dN3pef4Zs-hVLtH"
    private let ClarifaiAccessTokenKey = "ClarifaiAccessTokenKey"
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func ClarifaiSet(accessToken: String) {
        userDefaults.setObject(accessToken, forKey: ClarifaiAccessTokenKey)
    }
    
    func ClarifaiAccessToken() -> String? {
        return userDefaults.objectForKey(ClarifaiAccessTokenKey) as? String
    }
    
}
