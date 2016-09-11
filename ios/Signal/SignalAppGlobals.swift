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

    private let kUserLanguageKey = "kUserLanguageKey"
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func setUserLanguage(languageCode: String) {
        userDefaults.setObject(languageCode, forKey: kUserLanguageKey)
    }
    
    func userLanguage() -> String {
        return userDefaults.objectForKey(kUserLanguageKey) as? String ?? "fr"
    }
    
}
