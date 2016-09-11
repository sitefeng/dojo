//
//  NetworkRequests.swift
//  Signal
//
//  Created by Si Te Feng on 9/11/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit
import Alamofire

final internal class NetworkRequests: NSObject {

    static let tempURL = "https://de65f153.ngrok.io/verify"
    
    static let BaseURL = "https://de65f153.ngrok.io"
    static let VerifyPath = "/verify"
    static let LookupPath = "/lookup"
    static let WordsPath = "/words"
    
    /// - Param: completionBlock (RequestSuccessful, scavengerResult, related words/ associations)
    func verify(photoData: NSData, itemName: String, completionBlock: (Bool, Bool, [AssociationItem]) -> Void) {
        
        let userLanguageData = SignalAppGlobals.sharedInstance.userLanguage().dataUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: NetworkRequests.BaseURL + NetworkRequests.VerifyPath)
        let urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPMethod = "POST"
        
        
        Alamofire.upload(urlRequest, multipartFormData: { (multiformData) in
            multiformData.appendBodyPart(data: userLanguageData, name: "language")
            multiformData.appendBodyPart(data: itemName.dataUsingEncoding(NSUTF8StringEncoding)!, name: "name")
            multiformData.appendBodyPart(data: photoData, name: "image", fileName: "iphoneUpload.jpg", mimeType: "jpg")
            
            }) { (dataEncodingResult) in
                
            switch dataEncodingResult {
            case .Success(let uploadRequest, _, _):
                
                uploadRequest.responseJSON(completionHandler: { (response) in
                    
                    var dataDict = ["associations":[], "result":0]
                    do {
                        dataDict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: [.AllowFragments]) as! [String : NSObject]
                    } catch {
                        completionBlock(false, false, [])
                        return
                    }
                    
                    print(dataDict)
                    
                    // array of associations
                    let associationDicts: [AnyObject] = dataDict["associations"] as! [AnyObject]
                    
                    let associations = associationDicts.map({ (dict) -> AssociationItem in
                        return AssociationItem(rawDictionary: dict as! [String: AnyObject])
                    })
                    
                    let scavengerSuccessful = dataDict["result"] as! Bool
                    
                    completionBlock(true, scavengerSuccessful, associations)
                })
                
            case .Failure(let encodingError):
                print(encodingError)
                completionBlock(false, false, [])
            }
        }
        
    }
    
    
    //eg: http://localhost:5000/words?language=es&list=apple,orange,pear,banana
    func translate(englishWords: [String], index: NSInteger = 0, destinationLanguage: String = "default", completionBlock: (Bool, NSInteger, [String]) -> Void) {
        
        guard englishWords.count > 0 else {
            completionBlock(true, index, [])
            return
        }
        
        var userLanguage = SignalAppGlobals.sharedInstance.userLanguage()
        if destinationLanguage != "default" {
            userLanguage = destinationLanguage
        }
        
        var urlPath = NetworkRequests.BaseURL + NetworkRequests.WordsPath
        
        //Custom
        urlPath += "?language=\(userLanguage)&list=\(englishWords[0])"
        
        for i in 1..<englishWords.count {
            let word = englishWords[i]
            urlPath += ",\(word)"
        }
        
        Alamofire.request(.GET, urlPath, parameters: nil, encoding: ParameterEncoding.URL, headers: nil).response { (request, response, data, error) in
            guard error == nil else {
                print("error: \(error)")
                completionBlock(false, index, [])
                return
            }
            
            var translatedWordsAny: AnyObject?
            do {
                translatedWordsAny = try NSJSONSerialization.JSONObjectWithData(data!, options: [.AllowFragments])
            } catch {
                print("error translating")
                completionBlock(false, index, [])
                return
            }
            
            guard let translatedWords = translatedWordsAny?["words"] as? [String] else {
                print("error translating")
                completionBlock(false, index, [])
                return
            }
            
            completionBlock(true, index, translatedWords)
        }
    }
    
    
    
    
    
    
    
    
    
    
}
